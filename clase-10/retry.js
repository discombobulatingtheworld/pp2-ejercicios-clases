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
            reject(`Timeout after ${milisecs}`)
        })
    })
    return promise
}

async function retry(valueFn, retryFn) {
    let counter = 0;
    const startTime = Date.now()
    while (true)
    {
        try {
            return await valueFn();
        } catch (error) {
            counter++;
            let newTimeout = retryFn(counter,Date.now() - startTime);
            if(newTimeout > 0){
                await delay(newTimeout);
            }   
            else{
                throw error
            }
        }
    }
}

async function auxRetry(valueFn, retryFn) {
    await retry(valueFn,retryFn).then(value => {
        console.log(`Valor final = ${value}`);
    }).catch(e => {
        console.log(e);
    })
}



async function main(){
    await auxRetry(() => Promise.resolve(5),(retryAmount,retryTimeout) => {
        return (2-retryAmount)*100;
    })
    
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        return false
    })
    
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`RetryAmount = ${retryAmount}`)
        return (3-retryAmount)*100;
    })
}

main()