import pg from 'pg'
import * as fs from 'fs';

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
            tableDict[row.table_name.replace(" ","_")].push(row.column_name.replace(" ","_")) //Breaks cuz some attributes on table have spaces in them
        }
        else{
            tableDict[row.table_name.replace(" ","_")] = [row.column_name.replace(" ","_")]
        }
    })
    const tableRelations = await client.query('select pks.table_name as pk_table, fks.table_name as fk_table \nfrom information_schema.referential_constraints rc \njoin information_schema.table_constraints fks on rc.constraint_name = fks.constraint_name \njoin information_schema.table_constraints pks on rc.unique_constraint_name = pks.constraint_name')
    const relationsDict = {}

    tableRelations.rows.forEach((row) => {
        if(row.table_name in relationsDict){
            relationsDict[row.pk_table.replace(" ","_")].push(row.fk_table.replace(" ","_"))
        }
        else{
            relationsDict[row.pk_table.replace(" ","_")] = [row.fk_table.replace(" ","_")]
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
    outputToMarkdownFile(result)
}

function outputToMarkdownFile(data){
    var result = "```mermaid\n"+data+"\n```"
    fs.writeFile('./output/Output.md',result, (err) => {
        if (err) throw err.message;
    })
}
