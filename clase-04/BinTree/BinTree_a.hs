data BinTree a = TreeNode a (BinTree a) (BinTree a) | EmptyTree deriving (Eq, Show)

preorder :: BinTree a -> [a]
preorder (TreeNode a b c) = [a] ++ preorder b ++ preorder c
preorder EmptyTree = []


inorder :: BinTree a -> [a]
inorder (TreeNode a b c) = inorder b ++ [a] ++ inorder c
inorder EmptyTree = []


postorder :: BinTree a -> [a]
postorder (TreeNode a b c) = postorder b ++ postorder c ++ [a]
postorder EmptyTree = []