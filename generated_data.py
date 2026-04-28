import pandas as pd
import numpy as np
from faker import Faker
import random
import os

fake = Faker()
random.seed(42)
np.random.seed(42)
os.makedirs('data/raw', exist_ok=True)

# =============================================
#  STEP 1 — LOAD KAGGLE DATASET
# =============================================
print("Loading Kaggle dataset...")
df = pd.read_csv('data/raw/kaggle_telco.csv')
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')
df['TotalCharges'].fillna(df['MonthlyCharges'], inplace=True)

# =============================================
#  STEP 2 — BUILD customers.csv FROM KAGGLE
# =============================================
print("Building customers.csv from Kaggle data...")

contract_to_plan = {
    'Month-to-month': 'PLAN_A',
    'One year':       'PLAN_B',
    'Two year':       'PLAN_C'
}
gender_map = {'Male': 'M', 'Female': 'F'}
cities = ['Cairo', 'Alexandria', 'Giza', 'Luxor', 'Aswan', 'Mansoura', 'Tanta']

def get_segment(row):
    if row['Contract'] == 'Two year':   return 'Business'
    elif row['Contract'] == 'One year': return 'Postpaid'
    else:                               return 'Prepaid'

customers = pd.DataFrame({
    'customer_id':         df['customerID'],
    'name':                [fake.name() for _ in range(len(df))],
    'dob':                 [fake.date_of_birth(minimum_age=18, maximum_age=70).strftime('%Y-%m-%d') for _ in range(len(df))],
    'city':                [random.choice(cities) for _ in range(len(df))],
    'segment':             df.apply(get_segment, axis=1),
    'gender':              df['gender'].map(gender_map),
    'phone':               [f'01{random.randint(0,2)}{random.randint(10000000,99999999)}' for _ in range(len(df))],
    'plan_code':           df['Contract'].map(contract_to_plan),
    'tenure_months':       df['tenure'],
    'monthly_charges':     df['MonthlyCharges'],
    'kaggle_churn_label':  df['Churn']   # Used later to validate BSAT_CHURN_SCORE!
})
customers.to_csv('data/raw/customers.csv', index=False)
print(f'customers.csv done — {len(customers)} rows (REAL Kaggle data)')

cust_ids = customers['customer_id'].tolist()
churned  = set(customers[customers['kaggle_churn_label'] == 'Yes']['customer_id'])

# =============================================
#  STEP 3 — BUILD plans.csv FROM KAGGLE
# =============================================
print("Building plans.csv from Kaggle data...")

avg_fees = df.groupby('Contract')['MonthlyCharges'].mean().round(2)

plans = pd.DataFrame({
    'plan_code':      ['PLAN_A', 'PLAN_B', 'PLAN_C'],
    'plan_name':      ['Month-to-Month', 'One Year Contract', 'Two Year Contract'],
    'monthly_fee':    [avg_fees.get('Month-to-month', 65.0),
                       avg_fees.get('One year', 60.0),
                       avg_fees.get('Two year', 55.0)],
    'data_limit_gb':  [10, 30, 60],
    'validity_days':  [30, 365, 730]
})
plans.to_csv('data/raw/plans.csv', index=False)
print(f'plans.csv done — {len(plans)} rows (REAL Kaggle pricing)')

# =============================================
#  STEP 4 — GENERATE CDR (200,000 rows)
# =============================================
print("Generating cdr.csv...")
tower_ids  = [f'TOWER_{i:03d}' for i in range(1, 51)]
call_types = ['Voice', 'Data', 'SMS']

cdr_rows = []
for i in range(200000):
    cid = random.choice(cust_ids)
    is_churned = cid in churned
    dropped = random.choices([0, 1], weights=[70, 30] if is_churned else [95, 5])[0]
    cdr_rows.append({
        'call_id':      f'CALL_{i+1:07d}',
        'customer_id':  cid,
        'tower_id':     random.choice(tower_ids),
        'call_type':    random.choice(call_types),
        'duration_sec': random.randint(1, 3600),
        'cost':         round(random.uniform(0.1, 50.0), 2),
        'dropped_flag': dropped,
        'call_date':    fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d')
    })
cdr = pd.DataFrame(cdr_rows)
cdr.to_csv('data/raw/cdr.csv', index=False)
print(f'cdr.csv done — {len(cdr):,} rows (churned customers have higher drop rate)')

# =============================================
#  STEP 5 — GENERATE COMPLAINTS (8,000 rows)
# =============================================
print("Generating complaints.csv...")
complaint_types = ['Network Outage', 'Billing Error', 'Slow Data', 'Call Drop', 'SIM Issue']
statuses = ['Open', 'Resolved', 'Escalated']

comp_rows = []
for i in range(8000):
    cid = random.choice(list(churned)) if (random.random() < 0.6 and churned) else random.choice(cust_ids)
    comp_rows.append({
        'complaint_id':    f'COMP_{i+1:05d}',
        'customer_id':     cid,
        'tower_id':        random.choice(tower_ids),
        'complaint_type':  random.choice(complaint_types),
        'status':          random.choice(statuses),
        'resolution_days': random.randint(1, 45),
        'complaint_date':  fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d')
    })
pd.DataFrame(comp_rows).to_csv('data/raw/complaints.csv', index=False)
print(f'complaints.csv done — 8,000 rows')

# =============================================
#  STEP 6 — GENERATE PAYMENTS (15,000 rows)
# =============================================
print("Generating payments.csv...")
plan_fees    = dict(zip(plans['plan_code'], plans['monthly_fee']))
pay_methods  = ['Credit Card', 'Debit Card', 'Mobile Wallet', 'Cash']

pay_rows = []
for i in range(15000):
    cid  = random.choice(cust_ids)
    plan = customers[customers['customer_id'] == cid]['plan_code'].values[0]
    base = plan_fees.get(plan, 65.0)
    is_churned = cid in churned
    status = random.choices(['Success', 'Failed'], weights=[60, 40] if is_churned else [95, 5])[0]
    pay_rows.append({
        'payment_id':     f'PAY_{i+1:06d}',
        'customer_id':    cid,
        'plan_code':      plan,
        'amount':         round(base * random.uniform(0.95, 1.05), 2),
        'payment_method': random.choice(pay_methods),
        'payment_status': status,
        'payment_date':   fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d')
    })
pd.DataFrame(pay_rows).to_csv('data/raw/payments.csv', index=False)
print(f'payments.csv done — 15,000 rows')

# =============================================
#  STEP 7 — GENERATE DEVICES (one per customer)
# =============================================
print("Generating devices.csv...")
brands = ['Samsung', 'Apple', 'Xiaomi', 'Huawei', 'Oppo', 'Nokia']
os_map = {'Samsung': 'Android', 'Apple': 'iOS', 'Xiaomi': 'Android',
          'Huawei': 'Android', 'Oppo': 'Android', 'Nokia': 'Android'}

dev_rows = []
for i, cid in enumerate(cust_ids):
    brand = random.choice(brands)
    dev_rows.append({
        'device_imei': f'IMEI_{i+1:015d}',
        'customer_id': cid,
        'brand':       brand,
        'model':       fake.bothify(f'{brand}-??##'),
        'os':          os_map[brand],
        'sim_count':   random.choice([1, 2])
    })
pd.DataFrame(dev_rows).to_csv('data/raw/devices.csv', index=False)
print(f'devices.csv done — {len(dev_rows):,} rows')

print('\n✅ All 6 files ready in data/raw/')
print(f'   Real (Kaggle): {len(customers):,} customers, {len(plans)} plans')
print(f'   Synthetic: 200,000 CDR + 8,000 complaints + 15,000 payments + {len(dev_rows):,} devices')