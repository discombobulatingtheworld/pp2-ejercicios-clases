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

export function naiveSubsetSumArray(ns, target) {
  const xs = [...ns];
  while (xs.length > 0) {
    const x = xs.pop();
    if (x === target) {
      return [x];
    }
    for (const result of naiveSubsetSum(xs, target - x)) {
      return [x, ...result];
    }
  }
  return null;
} // function naiveSubsetSumArray

export function naiveSubsetSumParallelAux(problem) {
  return naiveSubsetSumParallel(problem["ns"], problem["target"]);
}

export function naiveSubsetSumParallel(ns, target) {
  return Promise.all(
    ns.map(
      (x, i) => {
        xs = [...ns].splice(i, 1);
        return betterWorkerFunction(
          (ns, t) => [...naiveSubsetSumArray(ns, t)]
        )(xs, target - t);
      }
    )
  );
}

export function testSubsetSum() {
  const [ns, target] = randomSubsetSumProblem();
  const startTime = Date.now();
  const firstSolution = naiveSubsetSum(ns, target).next().value ?? null;
  const time = (Date.now() - startTime) / 1e3;
  return { ns, target, firstSolution, time };
} // function testSubsetSum
