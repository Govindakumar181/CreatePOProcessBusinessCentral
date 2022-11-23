page 70200 PurchaseOrderDialog
{

    PageType = StandardDialog;
    Editable = true;
    Caption = 'Create Purchase Order';

    layout
    {
        area(content)
        {
            group(Detail)
            {
                field(SupplierNo; SupplierNo)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Supplier';
                    TableRelation = Vendor."No.";
                }
                field(Item; Item)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Item No.';
                    TableRelation = Item;
                }
                field(NoOfPO; NoOfPO)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'No. of Purchase Orders';
                }

            }

        }
    }

    var
        NoOfPO: Integer;

        SupplierNo: Code[20];
        Item: Code[20];


    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    var
        createPurchaseOrder: Codeunit CreatePurchaseOrderFromAPI;
        http_Cleint: HttpClient;
        http_ResponseMsg: HttpResponseMessage;
        response: Text;

    begin
        if CloseAction = Action::OK then begin
            if (http_Cleint.Get('https://jsonplaceholder.typicode.com/photos', http_ResponseMsg)) then begin
                http_ResponseMsg.Content.ReadAs(response);
                // Message(response);
                // createPurchaseOrder.CreateOrder(response, SupplierNo, Item, NoOfPO);
                createPurchaseOrder.CreateOrder2(response, SupplierNo, Item, NoOfPO);

            end;
        end
        else
            Message('PO Creation Cancelled');
        exit(true);
    end;

}