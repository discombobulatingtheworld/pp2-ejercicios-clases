import pg from 'pg'

const { Client, Config, QueryConfig } = pg

const client = new Client({
    user: "postgres",
    password: "password",
    database: "dvdrental",
    host: "localhost"
})
await client.connect()

try {
    const tableResult = await client.query('SELECT table_name, column_name from information_schema.columns \n WHERE table_schema = $1::text AND table_catalog = $2::text', ['public','dvdrental'])
    const tableDict = {}
    
    tableResult.rows.forEach((row) => {
        if(row.table_name in tableDict){
            tableDict[row.table_name].push(row.column_name)
        }
        else{
            tableDict[row.table_name] = [row.column_name]
        }
    })
    const tableRelations = await client.query('select pks.table_name as pk_table, fks.table_name as fk_table \nfrom information_schema.referential_constraints rc \njoin information_schema.table_constraints fks on rc.constraint_name = fks.constraint_name \njoin information_schema.table_constraints pks on rc.unique_constraint_name = pks.constraint_name')
    const relationsDict = {}

    tableRelations.rows.forEach((row) => {
        if(row.table_name in relationsDict){
            relationsDict[row.pk_table].push(row.fk_table)
        }
        else{
            relationsDict[row.pk_table] = [row.fk_table]
        }
    })
    buildMermaid(tableDict,relationsDict)
    
 } catch (err) {
    console.error(err);
 } finally {
    await client.end()
 }

 function buildMermaid(tableDict, relationsDict){
    var result = "erDiagram\n"
    Object.keys(tableDict).forEach((table) =>{
        if(table in relationsDict){
            const relations = relationsDict[table]
            relations.forEach((relation) => {
                result+=`   ${table} ||--o{ ${relation} : ${table}_${relation}\n`
            })
        }    
        result+=`   ${table} {\n`
        const columns = tableDict[table]
        columns.forEach((column) => {
            result+=`       string ${column}\n`
        })
        result+='   }\n'
    })
    console.log(result)
 }