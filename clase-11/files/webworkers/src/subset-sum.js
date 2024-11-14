import {
  betterWorkerFunction,
} from './utils';

export function randomSubsetSumProblem(args) {
  const {
    length = 25,
    maxValue = 500,
  } = args ?? {};
  const randNum = () => Math.floor(Math.random() * (maxValue + 1));
  const ns = [...new Set(Array.from({ length }, randNum))];
  const target = randNum();
  /* Math.random() < prob
    ? ns.reduce((s, n) => s + (Math.random() < prob ? n : 0))
    : randNum();*/
  return [ns, target];
} // function randomSubsetSumProblem

export function* naiveSubsetSum(ns, target) {
  const xs = [...ns];
  while (xs.length > 0) {
    const x = xs.pop();
    if (x === target) {
      yield [x];
    }
    for (const result of naiveSubsetSum(xs, target - x)) {
      yield [x, ...result];
    }
  }
} // function naiveSubsetSum

export function naiveSubsetSumArray(x, ns, target) {
  const xs = [...ns]
  if (x === target) {
    return [x];
  }
  if (xs.length === 0) {
    return [];
  }
  let results = [];
  for (const result of naiveSubsetSum(xs, target - x)) {
    results.push([x, ...result]);
  }
  return results;
} // function naiveSubsetSumArray

export function naiveSubsetSumParallel(ns, target) {
  return Promise.all(
    ns.map(
      (x, i) => {
        let xs = [...ns];
        xs.splice(i, 1);
        const workerFunctionCode = `  ${naiveSubsetSum}
${naiveSubsetSumArray}

const result = naiveSubsetSumArray(y, ys, t);
return [...result];`;
        const workerFunction = new Function("return " + `function (y, ys, t) {${workerFunctionCode}}`)();
        return betterWorkerFunction(workerFunction)(x, xs, target);
      }
    )
  );
} // function naiveSubsetSumParallel

export function testSubsetSum() {
  const [ns, target] = randomSubsetSumProblem();
  const startTime = Date.now();
  const firstSolution = naiveSubsetSum(ns, target).next().value ?? null;
  const time = (Date.now() - startTime) / 1e3;
  return { ns, target, firstSolution, time };
} // function testSubsetSum

export async function testSubsetSumParallel() {
  const ns = testCaseSubsetSumParallel['ns'];
  const target = testCaseSubsetSumParallel['target'];
  const startTime = Date.now();
  const results = await naiveSubsetSumParallel(ns, target);
  const solutions = results.filter(x => x.length > 0)
  let flatSolutions = [];
  for (const slice of solutions) {
    for (const solution of slice) {
      flatSolutions.push(solution);
    }
  }
  const time = (Date.now() - startTime) / 1e3;
  return { ns, target, flatSolutions, time };
} // function testSubsetSumParallel

const testCaseSubsetSumParallel = {
  "ns": [
      415,
      330,
      112,
      250,
      446,
      1,
      60,
      277,
      289,
      237,
      364,
      350,
      319,
      156,
      380,
      259,
      376,
      323,
      25,
      135,
      329,
      268,
      362,
      462,
      313
  ],
  "target": 431,
  "firstSolution": [
      25,
      156,
      250
  ],
  "time": 4.791
}