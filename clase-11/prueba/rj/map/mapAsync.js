function* nums(n) {
    for (let x = 0; x < n; x++) yield x;
}
async function asyncSquare(x) {
    return Promise.resolve(x ** 2);
}

async function mapAsync(ns, asyncFn) {
    let promises = []
    for (const x in ns) {
        promises.push(asyncFn(x));
    }
    return Promise.all(promises);
}


mapAsync([1,2,3,4,5], asyncSquare).then(console.log)