#!/usr/bin/env python3

def part_two():
    rotation = int(100050)
    count = 0
    previous_zero = 0
    with open("code.txt") as file:
        for line in file:
            # Add logic
            if line.count('R') > 0:
                newLine = line.replace('R', '')
                rotation_start = rotation
                rotation_end = rotation + int(newLine)
                rotation = rotation_end
                check_start = rotation_start%100
                check_end = rotation_end%100

                if check_end==0:
                    count += 1
                    previous_zero = 1
                else:
                    if previous_zero==1:
                        previous_zero = 0
                    else:
                        if check_end < check_start:
                            count += 1
                
                if (int(newLine) // 100) > 0:
                    extra = int(newLine) // 100
                    count += extra
            
            # Sub logic
            if line.count('L') > 0:
                newLine = line.replace('L', '')
                rotation_start = rotation
                rotation_end = rotation - int(newLine)
                rotation = rotation_end
                check_start = rotation_start%100
                check_end = rotation_end%100

                if check_end==0:
                    count += 1
                    previous_zero = 1
                else:
                    if previous_zero==1:
                        previous_zero = 0
                    else:
                        if check_end > check_start:
                            count += 1
                
                if (int(newLine) // 100) > 0:
                    extra = int(newLine) // 100
                    count += extra

        print('Final Count: ', count)


def part_one():
    rotation = int(100050)
    count = 0
    with open("code.txt") as file:
        for line in file:
            
            # Add logic
            if line.count('R') > 0:
                newLine = line.replace('R','')
                rotation = rotation + int(newLine)
                print('newline: ', int(newLine))
                check = rotation%100

            # Sub logic
            elif line.count('L') > 0:
                newLine = line.replace('L','')
                newLine = newLine.replace('\n', '')
                print('newline: ', int(newLine))
                rotation = rotation - int(newLine)
                check = rotation%100

            else:
                print("something wrong")
            if check==0:
                count += 1
    print("FINAL COUNT: ", count)

def main():
    part_two()
    #part_one()

if __name__=="__main__":
    main()
