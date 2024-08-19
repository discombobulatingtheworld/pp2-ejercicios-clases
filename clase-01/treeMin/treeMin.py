import math

def treeMin_rec(items):
    if not isinstance(items, list):
        return items
    else:
        return min([treeMin_rec(item) for item in items] + [math.inf])

def treeMin_inter(items: list):
    result_list = items.copy()
    while any([isinstance(item, list) for item in result_list]):
        aux_list = []
        for item in result_list:
            if isinstance(item, list):
                aux_list = aux_list + item
            else:
                aux_list.append(item)
        result_list = aux_list.copy()

    return min(result_list + [math.inf])

def main():
    print(treeMin_rec([1,7,[-1]]))
    print(treeMin_rec([[[0],1],2]))
    print(treeMin_rec([]))
    print(treeMin_rec([[],[[]],999]))
    
    print(treeMin_inter([1,7,[-1]]))
    print(treeMin_inter([[[0],1],2]))
    print(treeMin_inter([]))
    print(treeMin_inter([[],[[]],999]))

main()