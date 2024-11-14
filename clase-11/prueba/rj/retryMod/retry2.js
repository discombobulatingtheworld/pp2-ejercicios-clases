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

async function retryAsync(valueFn, retryFnAsync) {
    let counter = 0;
    const startTime = Date.now()
    while (true)
    {
        try {
            return await valueFn();
        } catch (error) {
            counter++;
            let newTimeout;
            try {
                newTimeout = await retryFnAsync(counter,Date.now() - startTime);
            }
            catch(e) {
                newTimeout = -1;
            }
            if(newTimeout > 0){
                await delay(newTimeout);
            }   
            else{
                throw error
            }
        }
    }
}

async function retryAsyncAux(valueFn, retryFn) {
    await retryAsync(valueFn,retryFn).then(value => {
        console.log(`Resolucion = ${value}`);
    }).catch(e => {
        console.log(`Error = ${e}`);
    })
}

async function main(){
    // Caso de prueba A:
    // Definir un caso de prueba con retryFun retornando una promesa resuelta con un número positivo.
    await retryAsyncAux(() => Promise.reject(new Error("Error in main promise")), (retryAmount, retryTimeout) => {
        console.log(`TestCase A: Execution count = ${retryAmount}.`)
        if (retryAmount > 3) {
            return Promise.reject(new Error("Ran out of retries."));
        }
        return delay(2000, 100);
    });

    // Caso de prueba B:
    // Definir un caso de prueba con retryFun retornando una promesa rechazada.
    await retryAsyncAux(() => Promise.reject(new Error("Error in main promise")), (retryAmount, retryTimeout) => {
        console.log(`TestCase B: Execution count = ${retryAmount}.`)
        return Promise.reject(new Error("Ran out of retries."));
    })
}

main()