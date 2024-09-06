
data BinTree a = TreeNode a (BinTree a) (BinTree a)
    | EmptyTree deriving (Eq, Show)

preorder :: BinTree a -> [a]
inorder :: BinTree a-> [a]
postorder :: BinTree a -> [a]

preorder EmptyTree = []
preorder (TreeNode root left right) = root:(preorder left) ++ (preorder right)

inorder EmptyTree = []
inorder (TreeNode root left right) = (inorder left) ++ root:inorder right

postorder EmptyTree = []
postorder (TreeNode root left right) = (postorder left) ++ (postorder right) ++ [root] 