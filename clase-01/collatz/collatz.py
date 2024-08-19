def collatz_recurs(num: int):
    if num <= 0:
        raise ValueError("Number must be greater than 0")
    elif num == 1:
        return 0
    
    if num % 2 == 0:
        return collatz_recurs(num / 2) + 1
    
    return collatz_recurs((num * 3) + 1) + 1

def collatz_iter(num: int):
    if num <= 0:
        raise ValueError("Number must be greater than 0")
    
    counter = 0

    while num != 1:
        if num % 2 == 0:
            num = num // 2
        else:
            num = 3 * num + 1
        counter += 1

    return counter

def main():
    nums = [
        42,
        4,
        3,
        2,
        17
    ]

    for num in nums:
        print(collatz_recurs(num))
        print(collatz_iter(num))

if __name__ == "__main__":
    main()