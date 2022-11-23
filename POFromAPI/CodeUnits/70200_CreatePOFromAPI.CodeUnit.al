codeunit 70200 CreatePurchaseOrderFromAPI
{
    trigger OnRun()
    var
    begin

    end;

    var
        POOrder: Record "Purchase Header";
        POLines: Record "Purchase Line";


    local procedure CreatePurchaseOrder(var SupplierNo: Code[20]; ItemNo: Code[20]; ItemQuantity: Decimal; CostAmount: Decimal) ReturnValue: Code[20]
    var
        POSetup: Record "Purchases & Payables Setup";
        NoMgt: Codeunit NoSeriesManagement;
        Post: Codeunit "Purch.-Post";


    begin
        POSetup.Get();


        POOrder.Reset();//header code ends here
        POOrder.Init();

        POOrder.Validate("Document Type", "Purchase Document Type"::Order);

        POOrder."No." := NoMgt.GetNextNo(POSetup."Order Nos.", WorkDate, true);

        POOrder.Validate("Buy-from Vendor No.", SupplierNo);

        // POOrder.Validate("Due Date", WorkDate());
        POOrder.Validate("Document Date", WorkDate());

        // POOrder.Validate("Payment Terms Code", '30 DAYS');

        POOrder.Insert(true);//header code ends here

        uerPurchaseLines(ItemNo, ItemQuantity, CostAmount, POOrder."No.");

        // POOrder.Receive := true;
        // Post.Run(POOrder);

        ReturnValue := POOrder."No.";

        // Message(ReturnValue);

    end;


    local procedure uerPurchaseLines(var ItemNo: Code[20]; ItemQuantity: Decimal; CostAmount: Decimal; PONo: Code[20]) ReturnValue: Integer
    var
    begin
        POLines.Reset();//line code starts here
        POLines.Init();

        POLines.Validate("Document Type", "Purchase Document Type"::Order);
        POLines.Validate("Document No.", PONo);
        POLines.Validate("Line No.", 1);
        POLines.Validate("Type", "Purchase Line Type"::Item);
        POLines.Validate("No.", ItemNo);
        POLines.Validate(Quantity, ItemQuantity);
        POLines.Validate("Direct Unit Cost", CostAmount);
        POLines.INSERT(true);//line code ends here

        ReturnValue := POLines."Line No.";
    end;


    procedure CreateOrder(response: Text; SupplierNo: Code[20]; ItemNo: Code[20]; NoOfPO: integer)

    var
        json_array: JsonArray;
        json_object: JsonObject;
        json_value: JsonValue;
        i: Integer;
        json_token: JsonToken;
        valuejToken: JsonToken;
        valuejToken2: JsonToken;
        ItemQuantities: Integer;
        ItemCost: Decimal;
        NoMgt: Codeunit NoSeriesManagement;
        POSetup: Record "Purchases & Payables Setup";
        PONumber: Code[20];
    begin
        POOrder.Reset();
        POLines.Reset();
        POSetup.Get();

        if json_token.ReadFrom(response) then begin

            if (json_token.IsArray()) then begin
                json_array := json_token.AsArray();

                for i := 0 to NoOfPO - 1 do begin

                    json_array.Get(i, json_token);

                    if (json_token.IsObject()) then begin
                        json_object := json_token.AsObject();

                        if (json_object.Get('userId', valuejToken)) then begin
                            if (valuejToken.IsValue()) then begin
                                ItemQuantities := valuejToken.AsValue().AsInteger();
                                // CreatePurchaseOrder(SupplierNo, ItemNo, ItemQuantities, 54)
                            end;
                        end;

                        if (json_object.Get('id', valuejToken)) then begin
                            if (valuejToken.IsValue()) then begin
                                ItemCost := valuejToken.AsValue().AsDecimal();
                            end;
                        end;

                        POOrder.Reset();
                        POOrder.Init();
                        POOrder."No." := NoMgt.GetNextNo(POSetup."Order Nos.", WorkDate, true);
                        // POOrder."No." := PONumber;
                        POOrder.Validate("Document Type", "Purchase Document Type"::Order);
                        POOrder.Validate("Buy-from Vendor No.", SupplierNo);
                        POOrder.Insert(true);

                        uerPurchaseLines(ItemNo, ItemQuantities, ItemCost, POOrder."No.");

                        // if (POOrder."No." = POOrder."No.") then begin

                        // end;
                        // POSetup.Get();
                        // POOrder."No." := NoMgt.GetNextNo(POSetup."Order Nos.", WorkDate, true)
                    end;

                end;
            end;
        end;
    end;


    procedure CreateOrder2(response: Text; SupplierNo: Code[20]; ItemNo: Code[20]; NoOfPO: integer)

    var
        json_array: JsonArray;
        json_object: JsonObject;
        json_value: JsonValue;
        i: Integer;
        json_token: JsonToken;
        valuejToken: JsonToken;
        ItemQuantities: Integer;
        ItemCost: Decimal;

    begin

        if json_token.ReadFrom(response) then begin

            if (json_token.IsArray()) then begin
                json_array := json_token.AsArray();

                for i := 0 to NoOfPO - 1 do begin

                    json_array.Get(i, json_token);

                    if (json_token.IsObject()) then begin
                        json_object := json_token.AsObject();

                        if (json_object.Get('albumId', valuejToken)) then begin
                            if (valuejToken.IsValue()) then begin
                                ItemQuantities := valuejToken.AsValue().AsInteger();
                            end;
                        end;

                        if (json_object.Get('id', valuejToken)) then begin
                            if (valuejToken.IsValue()) then begin
                                ItemCost := valuejToken.AsValue().AsDecimal();
                            end;
                        end;

                        CreatePurchaseOrder(SupplierNo, ItemNo, ItemQuantities, ItemCost);
                    end;

                end;
                Message('Order Created');

            end;
        end;
    end;

}

