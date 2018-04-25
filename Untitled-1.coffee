function importOrders(psInputs : PropertySet)
{
/*
 * Описание:
 * cервис импорта заказов
 *
 * Точки вызова:
 * данный сервис
 *
 * Входящие аргументы:
 *     FileName - путь к файлу импорта. 
 * 
 * Исходящие аргументы:
 *
 * История изменений:
 * 08.12.2017 -  - создан.
 */

	var psInput : PropertySet;
	var psOutput : PropertySet;
	var srvFileTrans : Service; 
	var strRow : String;	
	var sFileName : chars;					
	var arrRow : Array;
	var arrCol : Array;	
	var i : float;

	try
	{
		psInput = TheApplication().NewPropertySet();
		psOutput = TheApplication().NewPropertySet();
		srvFileTrans = TheApplication().GetService("EAI File Transport"); 
		
		sFileName = psInputs.GetProperty("FileName");

		psInput.SetProperty("FileName", sFileName); 
		psInput.SetProperty("CharSetConversion","UTF-8"); 
		srvFileTrans.InvokeMethod("Receive", psInput, psOutput); 
		strRow = psOutput.GetValue();	
		
		if (strRow != "")
		{	
			arrRow = new Array();
			arrRow = strRow.split("\n");
			arrCol = new Array();
			
			for (i = 1; i < arrRow.length-1; i++ )
			{
				strRow = arrRow[i].replace(/(\r|\n)/gm,"");
				arrCol = strRow.split("\t");

				psInput.Reset();
				psOutput.Reset();
			  	psInput.SetProperty("sOperationType", arrCol[0]);
				psInput.SetProperty("sSRNumber", arrCol[1]);
				psInput.SetProperty("sAccountAlias", arrCol[2]);
				psInput.SetProperty("sProductId", arrCol[3]);
				psInput.SetProperty("sOwnerLogin", arrCol[4]);
				psInput.SetProperty("sDivisionName", arrCol[5]);
				psInput.SetProperty("sInitiatorLogin", arrCol[6]);
				psInput.SetProperty("sProcessingType", arrCol[7]);
				psInput.SetProperty("sStatus", arrCol[8]);
				psInput.SetProperty("sSkillGroupName", arrCol[9]);
				prepareOrders(psInput, psOutput);
			}
		}		
		else
		{
			TheApplication.RaiseErrorText("Не удалось открыть файл.");
		}
	}
	finally
	{	
		srvFileTrans = null;
		psInput = null;
		psOutput = null;
	}
}