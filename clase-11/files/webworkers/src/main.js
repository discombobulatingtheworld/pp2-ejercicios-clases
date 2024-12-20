import './style.css';
import {
  naiveSubsetSum, randomSubsetSumProblem, testSubsetSum, naiveSubsetSumParallel, testSubsetSumParallel
} from './subset-sum';
import {
  newWorker, echoWorker, tickWorker, workerFunction,
} from './utils';

window.naiveSubsetSum = naiveSubsetSum;
window.randomSubsetSumProblem = randomSubsetSumProblem;
window.testSubsetSum = testSubsetSum;
window.naiveSubsetSumParallel = naiveSubsetSumParallel;
window.testSubsetSumParallel = testSubsetSumParallel;


window.newWorker = newWorker;
window.echoWorker = echoWorker;
window.tickWorker = tickWorker;
window.workerFunction = workerFunction;
