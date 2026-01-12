"""
Suno Analytics Funnel Dashboard

This script connects to DuckDB, queries the product funnel mart,
and visualizes the conversion funnel as a bar chart.
"""

import duckdb
import matplotlib.pyplot as plt
import os

# Connect to DuckDB database
# Assuming the database is in the same directory as the dbt project
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
db_path = os.path.join(project_root, 'suno_analytics', 'suno_analytics.duckdb')

# If database doesn't exist, create it
if not os.path.exists(db_path):
    print(f"Database not found at {db_path}. Please run 'dbt run' first.")
    exit(1)

conn = duckdb.connect(db_path)

# Query the funnel mart
query = """
SELECT 
    total_signups,
    users_with_first_song,
    users_with_first_export,
    paid_users
FROM mrt_product_funnel
"""

result = conn.execute(query).fetchone()

# Extract funnel metrics
total_signups = result[0]
users_with_first_song = result[1]
users_with_first_export = result[2]
paid_users = result[3]

# Calculate conversion rates
signup_to_song = (users_with_first_song / total_signups * 100) if total_signups > 0 else 0
song_to_export = (users_with_first_export / users_with_first_song * 100) if users_with_first_song > 0 else 0
export_to_paid = (paid_users / users_with_first_export * 100) if users_with_first_export > 0 else 0

# Prepare data for visualization
funnel_stages = ['Signups', 'First Song', 'First Export', 'Paid']
funnel_counts = [total_signups, users_with_first_song, users_with_first_export, paid_users]

# Create bar chart
plt.figure(figsize=(10, 6))
bars = plt.bar(funnel_stages, funnel_counts, color=['#4CAF50', '#2196F3', '#FF9800', '#9C27B0'])

# Add value labels on bars
for i, (bar, count) in enumerate(zip(bars, funnel_counts)):
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{int(count)}\n({funnel_counts[i-1]/funnel_counts[i]*100:.1f}%' if i > 0 and funnel_counts[i-1] > 0 else f'{int(count)}',
             ha='center', va='bottom', fontsize=10)

# Add conversion rate annotations
if total_signups > 0:
    plt.text(0, total_signups * 0.5, f'{signup_to_song:.1f}%', 
             ha='center', fontsize=9, style='italic', color='gray')
if users_with_first_song > 0:
    plt.text(1, users_with_first_song * 0.5, f'{song_to_export:.1f}%', 
             ha='center', fontsize=9, style='italic', color='gray')
if users_with_first_export > 0:
    plt.text(2, users_with_first_export * 0.5, f'{export_to_paid:.1f}%', 
             ha='center', fontsize=9, style='italic', color='gray')

plt.title('Suno Product Funnel: Signup → First Song → First Export → Paid', 
          fontsize=14, fontweight='bold')
plt.ylabel('Number of Users', fontsize=12)
plt.xlabel('Funnel Stage', fontsize=12)
plt.grid(axis='y', alpha=0.3, linestyle='--')

# Add summary text
summary_text = f"""
Total Signups: {total_signups}
First Song Conversion: {signup_to_song:.1f}%
First Export Conversion: {song_to_export:.1f}%
Paid Conversion: {export_to_paid:.1f}%
"""
plt.figtext(0.02, 0.02, summary_text, fontsize=9, 
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

plt.tight_layout()
output_path = os.path.join(script_dir, 'funnel_dashboard.png')
plt.savefig(output_path, dpi=300, bbox_inches='tight')
print(f"Funnel dashboard saved as '{output_path}'")
print(f"\nFunnel Metrics:")
print(f"  Total Signups: {total_signups}")
print(f"  Users with First Song: {users_with_first_song} ({signup_to_song:.1f}%)")
print(f"  Users with First Export: {users_with_first_export} ({song_to_export:.1f}%)")
print(f"  Paid Users: {paid_users} ({export_to_paid:.1f}%)")

conn.close()

