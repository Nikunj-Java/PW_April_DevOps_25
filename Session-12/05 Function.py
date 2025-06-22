def check_memory(usage):
    if usage> 75:
        return "High Memory Usage!"
    return "Memory is Normal"
print(check_memory(85))