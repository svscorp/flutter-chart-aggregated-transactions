# FlutterFlow Useful Custom Components

This repository contains various useful reusable components for your application

Available components:
1. Aggregated Transactions Chart (TransactionChart.dart)
2. Custom Taggable Text Field Widget (TaggableTextWidget.dart)

## 1. Aggregated Transactions Chart (TransactionChart.dart)

Simple chart that shows aggregated transactions per month for FlutterFlow

This repository is inspired by solving a pretty common task - creating a chart that shows aggregated transactions per month.

### Challenge

FlutterFlow has built-in chart component, but its datasource configuration plugs into your data (i.e. Firestore) with options to get all documents, filter them out and sort. It will then display all records on the chart. However, when you need to build some level of aggregation and display the data than - built-in component doesn't really help.

![image](https://github.com/user-attachments/assets/8385f73a-fcf2-47af-8285-f9351803e21f)

**Why not Custom Function or Custom Action for aggregation and supply it to built-in chart?**
1. Custom Functions are restricted with what type they return by FlutterFlow (i.e. you can't return `Future`) and what packages you can use in it (in fact, you can use only what's given to you by FF)
2. Custom Actions are better, and you can make use of `async` and add custom packages to use. However you can only asign this custom action to be `on page load` on root page component only. And then you run into a dozen of customization challenges.

### Mission (when you may need it)

You have a Firestore (or other data store) collection: 'transactions' that contains:

- amount (double)
- status (string)
- date (datetime)
- ... any other fields

**Given:** There are multiple transactions per months, some of them have status pending, some completed.
**When:** I open my app homepage
**Then:** I see a line chart, where I see last 6 months on the X axis and total amount (sum) of completed transactions
**And:** I am able to hover on the pointers for each month to see the value

### Solution

1. A charting library. There are plenty of them, I stopped by `syncfusion_flutter_charts`, it gives a vast selection of various chart types and configurations
2. Custom Widget. In FlutterFlow you go to "Custom Code"->"Add"->"Custom Widget"
3. You add a widget name, and dependencies on the right side of the interface: `syncfusion_flutter_charts: 27.1.50`
4. You can use the code of this repository. Don't worry, the parameters you won't need to add manually. On clicking "Save" the parameters will be autopopulated.

### Result

<img width="367" alt="image" src="https://github.com/user-attachments/assets/ae37cb65-b34b-450d-ba94-6d367ee18971">


### Features
1. Exposes configuration parameters
2. Aggregates per month
3. Trackball and X axis current position highlighting

* There are few things that can be improved of course, but starting with this can save you quite some time. Feel free to contribute back any improvements.

## 2. Custom Taggable Text Field Widget (TaggableTextWidget.dart + getTaggableTextWidgetCurrentValue.dart)

### Features
1. Exposes configuration parameter (prefixIcon)
2. Exposes Shared State, so it's available in Actions to set the value from