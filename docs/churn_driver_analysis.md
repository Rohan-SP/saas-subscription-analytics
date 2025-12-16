Churn Driver Analysis 

Ojective: To identify drivers of customer churn using product usage, support activity, and subscription as a means to decipher how churned users differ from non-churned users.

Churn analysis was conducted by joining the following cleaned datasets
- account data
- subscription data
- feature usage logs
- suppor ticket records 
- churn events

Usage Behaviour vs. Churn

Negligible difference between usage was found between churn and retained users
Churned users remained activiely engaged prior to churn
**Churn is not driven by low engagement**


Support Experience vs. Churn

Correlation between churn and support metrics are very weak
ticket_count, avg_resolution_time, and avg_satisfaction are all very close in amount between Retaiend and Churned
**Churn is not driven by support burden**


Revenue vs. Churn 
subscription value of churned vs. Ratained is identical
no strong correlation is observed between churn and the following metrics:
- MRR 
- Seat Count
- Plan Tier
- Billing Frequency
- Trial Status
**Churn is not driven by pricing and plan structure**


Key Takeaway
Overall correlation with chrun is weak accross all measured variables, which is likly due to the dataset being AI generated. 
Further qualitative signals are required, such as chrun reasons and customer feedback
