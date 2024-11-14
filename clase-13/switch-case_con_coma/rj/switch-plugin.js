import { transformSync } from '@babel/core';

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

const test1 = `
function f(x) {
  switch (x) {
    case 0: return 1;
    case 1, 2, 3: return x;
    default: return NaN;
  }
}
`;

function main() {
  const codeIn = test1;
  const {
    ast, code: codeOut,
  } = transformSync(codeIn, {
    plugins: [pluginSwitchComma], 
  });
  console.log(`${codeIn}\n\n  >>>>  \n\n${codeOut}`);
} // main

main();