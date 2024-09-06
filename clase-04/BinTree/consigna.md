# Ejercicio 3.2: BinTree

Definido un árbol binario de esta forma:

```haskell
data BinTree a = TreeNode a (BinTree a) (BinTree a)
	| EmptyTree deriving (Eq, Show)
```

Definir las funciones de recorrida `preorder`, `inorder` y `postorder`.

- `let leaf v = (TreeNode v EmptyTree EmptyTree)`
- `let tree1 = (TreeNode 7 (leaf 3) (leaf 9))`
- `preorder tree1 = [7, 3, 9]`
- `inorder tree1 = [3, 7, 9]`
- `postorder tree1 = [3, 9, 7]`
- `preorder EmptyTree = []`

# Soluciones

- [Opción A](./BinTree_a.hs)

## Opción A

```powershell
ghci> let leaf v = (TreeNode v EmptyTree EmptyTree)
ghci> let tree1 = (TreeNode 7 (leaf 3) (leaf 9))
ghci> preorder tree1
[7,3,9]
ghci> inorder tree1
[3,7,9]
ghci> postorder tree1
[3,9,7]
ghci> preorder EmptyTree
[]
```