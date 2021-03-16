public class SpfyCyumonJohoTxt {
    
    public interface ICyumonJohoTexter {
        String getText(SpfyApi_OrdersGetEx.Order pOrder);
    }
    public class CyumonJohoTexter implements ICyumonJohoTexter{
        public String getText(SpfyApi_OrdersGetEx.Order pOrder){

            String theText = '';
            String INDENT = '　　';
            {
                theText += String.format('注文番号 : {0}', 
                    new List<String>{ 
                        String.isBlank(pOrder.name) ? '' : pOrder.name
                    }
                );
                theText += '\r\n';
    
                theText += String.format('注文日時 : {0}', 
                    new List<String>{ 
                        pOrder.created_at == null ? '' : String.valueOf(pOrder.created_at)
                    }
                );
                theText += '\r\n';
            }

            theText += '\r\n';

            {//商品
                theText += '商品 : '; theText += '\r\n';
    
                Integer theLineItemCount = 0;
                for(SpfyApi_OrdersGetEx.LineItem aLineItem : pOrder.line_items){
                    theLineItemCount ++;
    
                    String theHinmeiText =
                        String.format('{0}. {1}', 
                            new List<String>{
                                String.valueOf(theLineItemCount),
                                aLineItem.title
                            }
                        );
                    if( !String.isBlank(aLineItem.sku) ) theHinmeiText += ' (' + aLineItem.sku + ')';
                    theText += theHinmeiText; theText += '\r\n';
                    
                    List<String> variant_options = 
                        String.isBlank(aLineItem.variant_title)
                        ? new List<String>()
                        : aLineItem.variant_title.split(' / ');
                    
                    if( variant_options.size() > 0 || aLineItem.properties.size() > 0 ){
                        theText += INDENT; theText += 'オプション : '; theText += '\r\n';
                        for(String aVariantOption : variant_options){
                            theText += (INDENT+INDENT); theText += aVariantOption; theText += '\r\n';
                        }
                        for(SpfyApi_OrdersGetEx.Prop aProp : aLineItem.properties){
                            theText += (INDENT+INDENT); theText += aProp.getPropText(); theText += '\r\n';
                        }
                    }
    
                    theText += INDENT; theText += String.format('数量 : {0}', new List<String>{ String.valueOf(aLineItem.quantity) }) ; theText += '\r\n';
    
                    theText += '\r\n';
                }
            }

            {//注文金額
                theText += '合計金額 : ' + pOrder.total_price.format() + '\r\n';
            }
            {//支払方法
                theText += '支払方法 : ';
                theText += sche_Pickls.tryGetLabel(
                    'SpfyOrder__c',
                    'gateway__c',
                    pOrder.gateway,
                    pOrder.gateway
                );
                theText += '\r\n';
                theText += '\r\n';
            }


            {//届け先
                theText += 'お届け先 : '; theText += '\r\n';
    
                theText += INDENT;
                theText += String.format('お客様名 : {0} {1}様', 
                    new List<String>{ 
                        String.isBlank(pOrder.shipping_address.last_name) ? '' : pOrder.shipping_address.last_name, 
                        String.isBlank(pOrder.shipping_address.first_Name) ? '' : pOrder.shipping_address.first_Name
                    }
                );
                theText += '\r\n';
    
                theText += INDENT;
                theText += String.format('郵便番号 : {0}', 
                    new List<String>{ String.isBlank(pOrder.shipping_address.zip) ? '' : pOrder.shipping_address.zip }
                );
                theText += '\r\n';
    
                theText += INDENT;
                theText += String.format('住所 : {0}{1}{2}{3}', 
                    new List<String>{ 
                        String.isBlank(pOrder.shipping_address.province) ? '' : pOrder.shipping_address.province, 
                        String.isBlank(pOrder.shipping_address.city) ? '' : pOrder.shipping_address.city,
                        String.isBlank(pOrder.shipping_address.address1) ? '' : pOrder.shipping_address.address1,
                        String.isBlank(pOrder.shipping_address.address2) ? '' : pOrder.shipping_address.address2
                    }
                );
                theText += '\r\n';
    
                theText += INDENT;
                theText += String.format('電話番号 : {0}', 
                    new List<String>{ 
                        String.isBlank(pOrder.shipping_address.phone) ? '' : pOrder.shipping_address.phone
                    }
                );
                theText += '\r\n';
            }
    
            return theText;
        }
    }


}