function fn(promise){
    return new Promise((res,rej) =>{
        promise.then(res,rej);
    })
}

console.log(fn(Promise.resolve(5)))