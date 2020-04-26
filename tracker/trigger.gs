/**
 * This function updates a very specific cell in the sheet at regular interval, which can be used as argument of the "ImportJSON" function, which will force update the sheet's values.
 *
 * This function must be triggered by App Scripts trigger configured as follow:
 *   - Event source: Time driven
 *   - Type of time based trigger: Minutes timer (you can configure this as you wish, based on your use-case and usage)
 *   - Interval: 5 minutes (you can configure this as you wish, based on your use-case and usage)
 *
 * To configure the trigger, go to:
 * https://script.google.com/home/ -> All projects -> "U score - Template - TypeForm API Connector" (the name of your project)
 *
 * @see https://script.google.com/home/triggers
 **/
function triggerAutoRefresh() {  
  SpreadsheetApp.getActive().getSheetByName('get_visors').getRange(1, 2).setValue(getRandomInt(1, 150)); // Updates the "B1" cell
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}