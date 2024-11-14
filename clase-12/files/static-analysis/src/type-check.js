import readline from 'node:readline';
import { parse } from '@babel/core';

function evalType(exp, symbols) {
  if (typeof exp === 'string') {
    exp = parse(exp)?.program?.body?.[0]?.expression;
  }
  switch (exp.type) {
    case 'NumericLiteral': {
      return 'number';
    }
    case 'BinaryExpression': {
      const leftType = evalType(exp.left, symbols);
      const rightType = evalType(exp.right, symbols);
      switch (exp.operator) {
        case '+': // FIXME ¿Es correcto esto?
        case '*': {
          if (leftType === 'number' && rightType === 'number') {
            return 'number';
          } else {
            throw new TypeError(`Invalid types ${leftType} & ${rightType} for operator ${exp.operator}!`);
          }
        }
        default: throw new SyntaxError(`Operator ${exp.operator} not supported yet!`);
      }
    }
    default: throw new SyntaxError(`Nodes ${exp.type} not supported yet!`);
  }
} // function evalType

async function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: true,
  });
  rl.on('line', (line) => {
    if (line.trim().length > 0) {
      console.log(`typeof ${line} >>>> ${evalType(line)}`);
    } else {
      process.exit();
    }
  });
} // main

main();