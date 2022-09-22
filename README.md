# CP-Homework

### 環境

* 語言：Swift
* Xcode 版本： 13.2.1
* Deployment： 13.0

### 介紹

* 此專案使用 struct 描述 GraphQL query 呼叫 GraphQL API，並將回傳 JSON 轉成 swift instance
  * 用 struct 定義 GraphQL query 方便後續擴充 query
  * API 層使用泛型，方便後續擴充其他 model

### 程式架構

* Protocol
  * GQLQueryProtocol 負責產生 GraphQL query string
    * operationType 提供 query, mutation，預設為 query
    * parameters 有需要可額外傳入參數
* API
  * APIManager 負責處理 API 層，將回傳 JSON 轉成 Swift Instance
* API Model
  * 定義 mocki.io 範例中 API model
  
### 參考

* Mock and Fake GraphQL API
  * https://mocki.io/graphql
* Mock and Fake GraphQL API Playground
  * https://api.mocki.io/playground?endpoint=https://api.mocki.io/v2/c4d7a195/graphql
  
### 畫面呈現
  
  * Project

  ![GraphQLExample](https://user-images.githubusercontent.com/12155964/191786797-bf63ed21-4789-4b0d-942c-16bf188efaf6.gif)

  * Unit Test
  
  ![GraphQLUnittest](https://user-images.githubusercontent.com/12155964/191785885-ea523506-5285-4323-80c1-cf0c63736faa.gif)
