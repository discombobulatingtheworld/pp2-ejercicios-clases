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
        console.log(`Resolucion = ${value}`);
    }).catch(e => {
        console.log(`Error = ${e}`);
    })
}


async function main(){
    // Caso de prueba 1: promesa que siempre se resuelve, con 3 reintentos y un tiempo de espera de 100ms.
    //      Se espera que la promesa se resuelva en el primer intento con el valor 5.
    await auxRetry(() => Promise.resolve(5),(retryAmount,retryTimeout) => {
        console.log(`TestCase 1: RetryAmount = ${retryAmount}.`)
        return 100;
    })
    
    // Caso de prueba 2: promesa que siempre falla, con 0 reintentos.
    //      Se espera que la promesa falle en el primer intento con el error "Error."
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 2: failing on first try.`)
        return false
    })
    
    // Caso de prueba 3: promesa que siempre falla, con 4 reintentos y un tiempo de espera de 300ms que decrece en 100ms cada intento.
    //      Se espera que la promesa falle luego del 4 intento con el error "Error."
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 3: RetryAmount = ${retryAmount}.`)
        return (4-retryAmount)*100
    })

    // Caso de prueba 4: promesa que falla durante los primeros 5 segundos.
    //      Se espera que la promesa falle una vez por segundo durante 5 segundos y luego resuelva con el valor "Success."
    let then = Date.now();
    let now;
    await auxRetry(() => {
        now = Date.now();
        return new Promise((resolve,reject) => {
            if (now - then < 5000){
                reject("Error")
            }
            else{
                resolve("Success")
            }
        });
    },(retryAmount,retryTimeout) => {
        console.log(`TestCase 4: RetryAmount = ${retryAmount}.`)
        return 1000;
    });

    // Caso de prueba 5: promesa que resuelve directamente incluso con retryFn que falla siempre.
    //      Se espera que la promesa resuelva directamente con el valor 42.
    await auxRetry(() => Promise.resolve(42),(retryAmount,retryTimeout) => {
        console.log(`TestCase 5: RetryAmount = ${retryAmount}.`)
        return -1;
    })

    // Caso de prueba 6: promesa que resuelve con un error en el primer intento y retryFn que devuelve 100ms siempre.
    //      Se espera que la promesa resuelva con el error directamente a primera.
    await auxRetry(() => Promise.resolve(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 6: RetryAmount = ${retryAmount}.`)
        return 100;
    })

    // Caso de prueba 7: promesa que falla con el valor "8" en el primer intento, con 4 reintentos y un tiempo de espera de 300ms que decrece en 100ms cada intento.
    //      Se espera que la promesa falle con el valor "8" en el 4 intento.
    await auxRetry(() => Promise.reject(8),(retryAmount,retryTimeout) => {
        console.log(`TestCase 7: RetryAmount = ${retryAmount}.`)
        return (4-retryAmount)*100
    })

    // Caso de prueba 8: promesa que falla con el error "Error", con un tiempo de reintento variable entre 100ms y 500ms, pero que corta luego de 3 segundos.
    //      Se espera que la promesa falle con el error "Error".
    //      Se ejecuta 3 veces para verificar que la cantidad de reintentos sea variable.
    //      Existe igual posibilidad de que en una ejecucion se de que sea la misma cantidad.
    //      Multiples ejecuciones pretenden disminuir la probabilidad conjunta de que esto ocurra.
    //      Pero no se garantiza que no ocurra.
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 8a: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 3000 ? Math.floor(Math.random() * 400) + 100 : -1;
    })
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 8b: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 3000 ? Math.floor(Math.random() * 400) + 100 : -1;
    })
    await auxRetry(() => Promise.reject(new Error("Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 8c: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 3000 ? Math.floor(Math.random() * 400) + 100 : -1;
    })

    // Caso de prueba 9: promesa que falla con el error "Error" durante los primeros 3 segundos y resuelve posteriormente a 6, con un tiempo de reintento variable entre 100ms y 900ms, pero que corta luego de 4 segundos.
    //      Se espera que la promesa resuelva a 6 luego de fallar una cantidad e veces variable durante los primeros 3 segundos.
    then = Date.now();
    await auxRetry(() => {
        now = Date.now();
        return new Promise((resolve,reject) => {
            if (now - then < 3000){
                reject("Error")
            }
            else{
                resolve(6)
            }
        });
    },(retryAmount,retryTimeout) => {
        console.log(`TestCase 9a: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 4000 ? Math.floor(Math.random() * 800) + 100 : -1;
    })
    then = Date.now();
    await auxRetry(() => {
        now = Date.now();
        return new Promise((resolve,reject) => {
            if (now - then < 3000){
                reject("Error")
            }
            else{
                resolve(6)
            }
        });
    },(retryAmount,retryTimeout) => {
        console.log(`TestCase 9b: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 4000 ? Math.floor(Math.random() * 800) + 100 : -1;
    })
    then = Date.now();
    await auxRetry(() => {
        now = Date.now();
        return new Promise((resolve,reject) => {
            if (now - then < 3000){
                reject("Error")
            }
            else{
                resolve(6)
            }
        });
    },(retryAmount,retryTimeout) => {
        console.log(`TestCase 9c: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 4000 ? Math.floor(Math.random() * 800) + 100 : -1;
    })

    // Caso de prueba 10: promesa retry anidada, con 3 reintentos y un tiempo de espera de 100ms en la interna y 1000ms en la externa que corta luego de 5 segundos.
    //      Se espera que la promesa falle con el error "Internal Error" luego de 5 segundos.
    await auxRetry(() => retry(() => Promise.reject(new Error("Internal Error")),(retryAmount,retryTimeout) => {
        console.log(`TestCase 10i: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 300 ? 100 : -1;
    }),(retryAmount,retryTimeout) => {
        console.log(`TestCase 10e: RetryAmount = ${retryAmount}.`)
        return retryTimeout < 5000 ? 1000 : -1;
    })
}

main()