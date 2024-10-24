function delay(milisecs, value){
    promise = new Promise((resolve) =>{
        setTimeout(() =>
            {
                resolve(value === undefined ? Date.now() : value)
            }
        ,milisecs)
    })
    return promise
}

function waitFor(promise, milisecs){
    promise = new Promise((resolve,reject) =>{
        promise.then(resolve,reject)
        delay(milisecs).then(() => {
            reject(`Timeout after ${milisecs}ms!`)
        })
    })
    return promise
}


waitFor(delay(100),200).then(value =>{
    console.log(value)
}).catch(e => {
    console.log(e)
})


waitFor(delay(200),100).then(value => {
    console.log(value)
}).catch(e => {
    console.log(e)
})