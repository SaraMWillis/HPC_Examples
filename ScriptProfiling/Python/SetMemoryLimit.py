import resource, sys, tracemalloc, time

def memory_limit():
    soft, hard = 5368706371,5368706371 # 5 GB as an example
    resource.setrlimit(resource.RLIMIT_AS, (soft, hard))

if __name__ == '__main__':
    memory_limit()
    try:
        tracemalloc.start()
        for j in [int(1e9), int(1e4), int(1e5), int(1e6),int(1e7), int(1e8)]:
            print("populating list with %s elements"%j)
            test = list(range(0,j))
            current, peak = tracemalloc.get_traced_memory()
            print(f"Current memory usage is {current / 10**6}MB; Peak was {peak / 10**6}MB\n")
    except MemoryError:
        sys.stderr.write('\n\nERROR: Memory Exception\n')
        current, peak = tracemalloc.get_traced_memory()
        print(f"Current memory usage is {current / 10**6}MB; Peak was {peak / 10**6}MB\n")
        sys.exit(1)
