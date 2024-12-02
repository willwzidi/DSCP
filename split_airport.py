import os
import pandas as pd

# 设定每次读取的行数
chunk_size = 1000000  # 根据你的内存情况调整此值
filename = 'itineraries.csv'

# 创建输出目录
output_dir = 'output_chunks_filtered_airport'
os.makedirs(output_dir, exist_ok=True)

i = 0

# 使用分块读取
for chunk in pd.read_csv(filename, chunksize=chunk_size):
    i += 1
    print(f"Processing chunk {i}...")
    # 确保 searchDate 转换为 datetime 类型（便于分组和后续分析）
    chunk['searchDate'] = pd.to_datetime(chunk['searchDate'], errors='coerce')

    # 筛选特定舱位代码
    filtered_chunk = chunk[
        chunk['segmentsCabinCode'].isin(['coach||coach', 'coach', 'coach||coach||coach'])
    ]

    # 对 startingAirport、destinationAirport 和 isNonStop 进行分组
    grouped = filtered_chunk.groupby(['startingAirport', 'destinationAirport', 'isNonStop'])

    # 遍历每个分组并保存为单独的文件
    for (starting_airport, destination_airport, is_non_stop), group in grouped:
        if pd.isna(starting_airport) or pd.isna(destination_airport):
            # 跳过无效的组
            continue

        # 创建对应的文件夹路径
        non_stop_label = 'NonStop' if is_non_stop == 1 else 'Stop'
        folder_name = os.path.join(
            output_dir, f"{starting_airport}_{destination_airport}_{non_stop_label}"
        )
        os.makedirs(folder_name, exist_ok=True)

        # 构造文件名并保存为 CSV 文件
        file_name = os.path.join(folder_name, f"chunk_{i}.csv")
        group.to_csv(file_name, index=False)

    print(f"Chunk {i} processed and saved.")
