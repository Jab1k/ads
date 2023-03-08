f = open('File_part.txt','r')
# lst = ["Apple","Peach","Banana",]
# a = int(input('Kiriting: '))
# for i in lst:
#     print('salom')
#     for c in range(a):
#         print('hello')
#         f.write(i + '\n')
def search_str(word):
    with open('Salom.text', 'r') as file:
        content = file.read()
        if word in content:
            print('bor')
        else:
            print('yoq')
search_str('hello')
f.close()