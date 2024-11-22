import readline from 'node:readline';
import { parse } from '@babel/core';

function evaluateSum(leftType,rightType)
{
  if ((leftType === 'string' && rightType === 'number') || (leftType === 'number' && rightType === 'string') || (leftType === 'string' && rightType === 'string')){
    return 'string'
  }
  else {
    return 'number';
  } 
}

function evaluateMult(leftType,rightType)
{
  if ((leftType === 'string' && rightType === 'number') || (leftType === 'number' && rightType === 'string')){
    return 'string'
  }
  else {
    return 'number';
  }
}

function evaluateAndOr(leftType,rightType,operator){
  if(leftType === rightType){
    return leftType
  }
  else {
    throw new TypeError(`Cannot resolve ${leftType} ${operator} ${rightType}.`)
  }
}


function evalType(exp, symbols) {
  if (typeof exp === 'string') {
    exp = parse(exp)?.program?.body?.[0]?.expression;
  }
  switch (exp.type) {
    case 'NumericLiteral': {
      return 'number';
    }
    case 'StringLiteral':{
      return 'string'
    }
    case 'BooleanLiteral':{
      return 'boolean'
    }
    case 'BinaryExpression': {
      const leftType = evalType(exp.left, symbols);
      const rightType = evalType(exp.right, symbols);
      switch (exp.operator) {
        case '+': {
          return evaluateSum(leftType,rightType)
        }
        case '*': {
          return evaluateMult(leftType,rightType)
        }
        case '-':
        case '/':
        case '%':{
          return 'number'
        }
        case '==':
        case '!=':
        case '<':
        case '>':
        case '<=':
        case '>=':{
          return 'boolean'
        }
      }
    }
    case 'LogicalExpression':{
      const leftType = evalType(exp.left, symbols);
      const rightType = evalType(exp.right, symbols);
      switch(exp.operator){
        case '&&':
        case '||':{
          return evaluateAndOr(leftType,rightType,exp.operator)
        }
      }
    }
    case 'UnaryExpression':{
      switch(exp.operator){
        case '!':{
            return 'boolean'
        }
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

testEvalType();
// main();

function testEvalType() {
  const testArray = [
    ["5+5","number"],["true+true","number"],["5+\"hola\"","string"],["5+true","number"],["\"hola\"+\"hola\"","string"],
    ["\"hola\"*5","string"],["\"hola\"*\"hola\"","number"],["5*5","number"],["5*true","number"],["true*true","number"],
    ["5-5","number"],["5-\"hola\"","number"],["5-true","number"],["\"hola\"-\"hola\"","number"],["\"hola\"-true","number"],["false-true","number"],
    ["5/5","number"],["5/\"hola\"","number"],["5/true","number"],["\"hola\"/\"hola\"","number"],["\"hola\"/true","number"],["false/true","number"],
    ["5%5","number"],["5%\"hola\"","number"],["5%true","number"],["\"hola\"%\"hola\"","number"],["\"hola\"%true","number"],["false%true","number"],
    ["5==5", "boolean"], ["5==\"hola\"", "boolean"], ["5==true", "boolean"], ["\"hola\"==\"hola\"", "boolean"], ["\"hola\"==true", "boolean"], ["false==true", "boolean"],
    ["5!=5", "boolean"], ["5!=\"hola\"", "boolean"], ["5!=true", "boolean"], ["\"hola\"!=\"hola\"", "boolean"], ["\"hola\"!=true", "boolean"], ["false!=true", "boolean"],
    ["5<5", "boolean"], ["5<\"hola\"", "boolean"], ["5<true", "boolean"], ["\"hola\"<\"hola\"", "boolean"], ["\"hola\"<true", "boolean"], ["false<true", "boolean"],
    ["5>5", "boolean"], ["5>\"hola\"", "boolean"], ["5>true", "boolean"], ["\"hola\">\"hola\"", "boolean"], ["\"hola\">true", "boolean"], ["false>true", "boolean"],
    ["5<=5", "boolean"], ["5<=\"hola\"", "boolean"], ["5<=true", "boolean"], ["\"hola\"<=\"hola\"", "boolean"], ["\"hola\"<=true", "boolean"], ["false<=true", "boolean"],
    ["5>=5", "boolean"], ["5>=\"hola\"", "boolean"], ["5>=true", "boolean"], ["\"hola\">=\"hola\"", "boolean"], ["\"hola\">=true", "boolean"], ["false>=true", "boolean"],
    ["5&&5", "number"], ["\"hola\"&&\"hola\"", "string"],["false&&true", "boolean"],
    ["5||5", "number"], ["\"hola\"||\"hola\"", "string"],["false||true", "boolean"],
    ["!5","boolean"], ["!true","boolean"], ["!\"hola\"","boolean"]
    ];
  testArray.forEach(element => {
    console.assert(evalType(element[0]) === element[1], `Test de ${element[0]} no otorga ${element[1]}`);
  });
}