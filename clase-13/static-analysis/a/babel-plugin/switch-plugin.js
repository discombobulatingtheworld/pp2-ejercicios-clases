import { transformSync } from '@babel/core';
import * as t from "@babel/types";

// Check <https://babeljs.io/docs/babel-types>.
function pluginSwitchComma({ types: t }) {
  return {
    visitor: {
      SwitchStatement(path) {
        path.node.cases = [...(function* () {
          for (const c of path.node.cases) {
            if (c.test?.type === 'SequenceExpression') {
              for (const caseTest of c.test.expressions.slice(0, -1)) {
                yield t.switchCase(caseTest, []);
              }
              yield t.switchCase(c.test.expressions.at(-1), c.consequent);
            } else {
              yield c;
            }
          }
        })()];
      }
    } // visitor
  };
}; // function pluginSwitchComma


function _algebraicSimplification(path) {
  if (path.node.left.type === 'NumericLiteral' && path.node.right.type === 'NumericLiteral') {
    switch(path.node.operator) {
      case '+':
      case '-':
        if (path.node.left.value === 0) {
          path.replaceWith(path.node.right);
        }
        else if (path.node.right.value === 0) {
          path.replaceWith(path.node.left);
        }
        else return false;
        break;
      case '*':
        if (path.node.left.value === 0 || path.node.right.value === 0) {
          path.replaceWith(t.numericLiteral(0));
        }
        else if (path.node.left.value === 1) {
          path.replaceWith(path.node.right);
        }
        else if (path.node.right.value === 1) {
          path.replaceWith(path.node.left);
        }
        else return false;
        break;
      case '/':
        if (path.node.right.value === 1) {
          path.replaceWith(path.node.left);
        }
        else return false;
        break;
      case '%':
        if (path.node.right.value === 1) {
          path.replaceWith(t.numericLiteral(0));
        }
        else return false;
        break;
      case '^':
        if (path.node.right.value === 0) {
          path.replaceWith(t.numericLiteral(1));
        }
        else if (path.node.right.value === 1) {
          path.replaceWith(path.node.left);
        }
        else return false;
        break;
      default:
        return false; 
    }
  }
  return true;
} // _algebraicSimplification

function _constantFolding(path) {
  if (path.node.left.type === 'NumericLiteral' && path.node.right.type === 'NumericLiteral') {
    let value;
    switch(path.node.operator) {
      case '+':
        value = path.node.left.value + path.node.right.value;
        break;
      case '-':
        value = path.node.left.value - path.node.right.value;
        break;
      case '*':
        value = path.node.left.value * path.node.right.value;
        break;
      case '/':
        value = path.node.left.value / path.node.right.value;
        break;
      case '%':
        value = path.node.left.value % path.node.right.value;
        break;
      default:
        return false;
    }
    path.replaceWith(t.numericLiteral(value));
    return true;
  }
  return false;
}

function pluginOptimize({ types: t}) {
  return {
    visitor: {
      BinaryExpression: {
        exit(path) {
          for (const opt of [
            { 'type': 'algebraic simplification', 'func': _algebraicSimplification },
            { 'type': 'constant folding', 'func': _constantFolding }
          ]) {
            if (((parm) => { 
              const result = opt['func'](parm); 
              if (result) console.log(`Applied ${opt['type']}`);
              return result;
            })(path)) {
              break;
            }
          }
        }
      }
    } // visitor
  };
}; // function pluginSwitchComma

const testForCase = `
function f(x) {
  switch (x) {
    case 0: return 1;
    case 1, 2, 3: return x;
    default: return NaN;
  }
}
`;

const testForConstantFolding1 = `
function f(x) {
  return 20 + 5;
}
`;

const testForAlebraicSimplification1 = `
let y = 0 + 9
`;

const testForConstantFolding2 = `
let x = 3 + 9 * 7;
`;

const testForAlebraicSimplification2 = `
let x = 3 + 0 * 7;
`;

function test(codeIn) {
  const {
    ast, code: codeOut,
  } = transformSync(codeIn, {
    plugins: [pluginOptimize], 
  });
  console.log(`${codeIn}\n\n  >>>>  \n\n${codeOut}`);
}

function main() {
  let idx = 0;
  for (const testCase of [testForConstantFolding1, testForConstantFolding2, testForAlebraicSimplification1, testForAlebraicSimplification2]) {
    console.log(`\n\nRunning test case ${++idx}\n====================\n`);
    test(testCase);
  }
} // main

main();