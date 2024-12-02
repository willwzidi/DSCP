import os
import pandas as pd

# 定义输入目录（之前生成的文件夹）和输出目录
input_dir = 'output_chunks_date'
output_dir = 'merged_files_date'
os.makedirs(output_dir, exist_ok=True)

# 遍历输入目录下的所有子文件夹
for folder_name in os.listdir(input_dir):
    folder_path = os.path.join(input_dir, folder_name)
    
    # 检查是否为目录（避免处理非文件夹内容）
    if os.path.isdir(folder_path):
        print(f"Processing folder: {folder_name}...")
        
        # 初始化一个空的 DataFrame
        combined_df = pd.DataFrame()
        
        # 遍历子文件夹内的所有文件
        for file_name in os.listdir(folder_path):
            file_path = os.path.join(folder_path, file_name)
            
            # 确保只处理 CSV 文件
            if file_name.endswith('.csv'):
                # 读取文件并追加到 DataFrame
                chunk = pd.read_csv(file_path)
                combined_df = pd.concat([combined_df, chunk], ignore_index=True)
        
        # 将拼接后的 DataFrame 保存为新的文件
        output_file_path = os.path.join(output_dir, f"{folder_name}.csv")
        combined_df.to_csv(output_file_path, index=False)
        print(f"Saved merged file: {output_file_path}")

print("All files processed and merged.")
