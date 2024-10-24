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

delay(100).then(value =>{
    console.log(value)
})
delay(200, "time!").then(value =>{
    console.log(value)
})
delay(300, null).then(value =>{
    console.log(value)
})