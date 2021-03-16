public class ShiryoSofuTeianShisetsu {
    
    private static Map<String, List<Tokyo23KuShisetsuWrap>> shikugunIdTokyo23KuKasobaMap = new Map<String, List<Tokyo23KuShisetsuWrap>>{
        'a0v7F000000aRqeQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場'),    new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')},  // 東京都練馬区
        'a0v7F000000aRqKQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場'),  new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場')},  // 東京都目黒区
        'a0v7F000000aRqEQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')},  // 東京都墨田区
        'a0v7F000000aRqYQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')},    // 東京都北区
        'a0v7F000000aRqWQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場'),    new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場')},    // 東京都豊島区
        'a0v7F000000aRqAQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')},    // 東京都文京区
        'a0v7F000000aRqqQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都武蔵野市
        'a0v7F000000aRquQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都府中市
        'a0v7F000000aRqIQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場')}, // 東京都品川区
        'a0v7F000000aRqcQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場')}, // 東京都板橋区
        'a0v7F000000aRr1QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都東村山市
        'a0v7F000000aRrFQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都東久留米市
        'a0v7F000000aRqwQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都調布市
        'a0v7F000000aRqSQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都中野区
        'a0v7F000000aRq4QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場')}, // 東京都中央区
        'a0v7F000000aRqMQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場')}, // 東京都大田区
        'a0v7F000000aRqCQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')}, // 東京都台東区
        'a0v7F000000aRqgQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場')}, // 東京都足立区
        'a0v7F000000aRq2QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')}, // 東京都千代田区
        'a0v7F000000aRrRQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都西東京市
        'a0v7F000000aRqOQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', ' 堀ノ内斎場')}, // 東京都世田谷区
        'a0v7F000000aRqUQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')}, // 東京都杉並区
        'a0v7F000000aRq8QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場')}, // 東京都新宿区
        'a0v7F000000aRqzQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都小平市
        'a0v7F000000aRqyQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都小金井市
        'a0v7F000000aRqQQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場')}, // 東京都渋谷区
        'a0v7F000000aRqsQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都三鷹市
        'a0v7F000000aRr9QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都狛江市
        'a0v7F000000aRr3QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlXsQAK', '堀ノ内斎場')}, // 東京都国分寺市
        'a0v7F000000aRqaQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')}, // 東京都荒川区
        'a0v7F000000aRq6QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlXcQAK', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FleiQAC', '代々幡斎場')}, // 東京都港区
        'a0v7F000000aRqGQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')}, // 東京都江東区
        'a0v7F000000aRqkQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場')}, // 東京都江戸川区
        'a0v7F000000aRqiQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000Fld2QAC', '町屋斎場')}, // 東京都葛飾区
        'a0v7F000000aRoiQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場')}, // 埼玉県蕨市
        'a0v7F000000aRosQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')}, // 埼玉県和光市
        'a0v7F000000aRoxQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')}, // 埼玉県八潮市
        'a0v7F000000aRooQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlQkQAK', '落合斎場')}, // 埼玉県朝霞市
        'a0v7F000000aRoeQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX8QAK', '四ツ木斎場')}, // 埼玉県草加市
        'a0v7F000000aRoCQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場')}, // 埼玉県川口市
        'a0v7F000000aRoIQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlazQAC', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場')}, // 埼玉県所沢市
        'a0v7F000000aRokQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a0y7F000000FlNyQAK', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a0y7F000000FlX6QAK', '谷塚斎場')} // 埼玉県戸田市
    };

    private static Map<String, List<Tokyo23KuShisetsuWrap>> shikugunIdTokyo23KuSaijoMap = new Map<String, List<Tokyo23KuShisetsuWrap>>{
        'a0v7F000000aRqeQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場'),    new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')},  // 東京都練馬区
        'a0v7F000000aRqKQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場'),  new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場')},  // 東京都目黒区
        'a0v7F000000aRqEQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')},  // 東京都墨田区
        'a0v7F000000aRqYQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')},    // 東京都北区
        'a0v7F000000aRqWQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場'),    new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場')},    // 東京都豊島区
        'a0v7F000000aRqAQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'),    new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')},    // 東京都文京区
        'a0v7F000000aRqqQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都武蔵野市
        'a0v7F000000aRquQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都府中市
        'a0v7F000000aRqIQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場')}, // 東京都品川区
        'a0v7F000000aRqcQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場')}, // 東京都板橋区
        'a0v7F000000aRr1QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都東村山市
        'a0v7F000000aRrFQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都東久留米市
        'a0v7F000000aRqwQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都調布市
        'a0v7F000000aRqSQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都中野区
        'a0v7F000000aRq4QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場')}, // 東京都中央区
        'a0v7F000000aRqMQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場')}, // 東京都大田区
        'a0v7F000000aRqCQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')}, // 東京都台東区
        'a0v7F000000aRqgQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場')}, // 東京都足立区
        'a0v7F000000aRq2QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')}, // 東京都千代田区
        'a0v7F000000aRrRQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都西東京市
        'a0v7F000000aRqOQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', ' 堀ノ内斎場')}, // 東京都世田谷区
        'a0v7F000000aRqUQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')}, // 東京都杉並区
        'a0v7F000000aRq8QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場')}, // 東京都新宿区
        'a0v7F000000aRqzQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都小平市
        'a0v7F000000aRqyQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都小金井市
        'a0v7F000000aRqQQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場')}, // 東京都渋谷区
        'a0v7F000000aRqsQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都三鷹市
        'a0v7F000000aRr9QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都狛江市
        'a0v7F000000aRr3QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1YAAW', '堀ノ内斎場')}, // 東京都国分寺市
        'a0v7F000000aRqaQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')}, // 東京都荒川区
        'a0v7F000000aRq6QAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADZMAA4', '桐ヶ谷斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADvaAAG', '代々幡斎場')}, // 東京都港区
        'a0v7F000000aRqGQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')}, // 東京都江東区
        'a0v7F000000aRqkQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場')}, // 東京都江戸川区
        'a0v7F000000aRqiQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AErZAAW', '町屋斎場')}, // 東京都葛飾区
        'a0v7F000000aRoiQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場')}, // 埼玉県蕨市
        'a0v7F000000aRosQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')}, // 埼玉県和光市
        'a0v7F000000aRoxQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')}, // 埼玉県八潮市
        'a0v7F000000aRooQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADZLAA4', '落合斎場')}, // 埼玉県朝霞市
        'a0v7F000000aRoeQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場'), new Tokyo23KuShisetsuWrap('a3y2v000000AE1EAAW', '四ツ木斎場')}, // 埼玉県草加市
        'a0v7F000000aRoCQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場')}, // 埼玉県川口市
        'a0v7F000000aRoIQAU' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEC2AAO', '日華多磨葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場')}, // 埼玉県所沢市
        'a0v7F000000aRokQAE' => new List<Tokyo23KuShisetsuWrap>{new Tokyo23KuShisetsuWrap('a3y2v000000AEa5AAG', '戸田葬祭場'), new Tokyo23KuShisetsuWrap('a3y2v000000ADaFAAW', '谷塚斎場')} // 埼玉県戸田市
    };

    public class Tokyo23KuShisetsuWrap{
        public String shisetsuId = '';
        public String shisetsuName = '';
        public Tokyo23KuShisetsuWrap(String id, String name){
            shisetsuId = id;
            shisetsuName = name;
        }
    }
    
    public class TeianShisetsuListWrap {
        public String message = '';
        public List<TeianShisetsuWrap> standardKasobaList = new List<TeianShisetsuWrap>();
        public List<TeianShisetsuWrap> standardSaijoList = new List<TeianShisetsuWrap>();
    }

    public class TeianShisetsuWrap {
        public Boolean isKasoba = false;
        public String shisetsuKubun = '';
        public String shisetsuId = '';
        public String shisetsuName = '';
        public Boolean shutokenIchibuChiki = false;
    }

    public static TeianShisetsuListWrap getShiryoSofuTeianShisetsu(String shikugunId){
        System.debug('shikugunId:' + shikugunId);
        TeianShisetsuListWrap teianShisetsuListWrap = new TeianShisetsuListWrap();

        Shikugun__c shikugunMst = [select Id, AreaCode__c, Chiriichijouhou__latitude__s, Chiriichijouhou__longitude__s from Shikugun__c where Id = :shikugunId];

        Set<Id> kasobaSekoKanoAreaSet = new Set<Id>();
        Set<Id> saijoSekoKanoAreaSet = new Set<Id>();
        for(SekouKanouArea__c sekouKanouArea : [select Id, ShisetsuRef__c, ShisetsuRef__r.ShisetsuShubetsu__c, SimpleYasugoKeiyakuRef__r.Teikeisaki__c, SimpleYasugoKeiyakuRef__r.KeiyakuJokyo__c from SekouKanouArea__c where ShikugunRef__c = :shikugunId and SokyakuTeishi__c = false]){
            if(sekouKanouArea.ShisetsuRef__r.ShisetsuShubetsu__c == '火葬場' || sekouKanouArea.ShisetsuRef__r.ShisetsuShubetsu__c == '併設') kasobaSekoKanoAreaSet.add(sekouKanouArea.ShisetsuRef__c);
            if(sekouKanouArea.SimpleYasugoKeiyakuRef__r.KeiyakuJokyo__c == '契約中') saijoSekoKanoAreaSet.add(sekouKanouArea.SimpleYasugoKeiyakuRef__r.Teikeisaki__c);
        }
        if(kasobaSekoKanoAreaSet.size() == 0) teianShisetsuListWrap.message = '施行可能エリアがない地域です ';
        if(saijoSekoKanoAreaSet.size() == 0) teianShisetsuListWrap.message += '施行可能な葬儀社がありません';

        List<Shisetsu__c> kasobaList = [select Id, 
                                             Name, 
                                            KoeiMinei__c, 
                                            Shikugun__c, 
                                            ShutokenIchibuChiki__c 
                                        from Shisetsu__c 
                                        where Id = :kasobaSekoKanoAreaSet 
                                            and SogishaKensakuHihyoji__c = false 
                                            and ShokaiKinshi__c = false 
                                        order by DISTANCE(IdoKedo__c, GEOLOCATION(:shikugunMst.Chiriichijouhou__latitude__s,:shikugunMst.Chiriichijouhou__longitude__s), 'km') asc NULLS LAST];
        
        Set<Id> chkKasobaDuplicateIdSet = new Set<Id>();
        Integer koeiKasoba = 0;
        for(Shisetsu__c kasoba : kasobaList){

            if(teianShisetsuListWrap.standardKasobaList.size() >= 2) break;
            
            if(!chkKasobaDuplicateIdSet.contains(kasoba.Id) && 
                kasoba.KoeiMinei__c != '民営' && 
                kasoba.Shikugun__c == shikugunId && 
                koeiKasoba < 2 && 
                kasoba.Id != 'a0y7F000003BTUa'){ // 西寺尾会堂は除外
                
                chkKasobaDuplicateIdSet.add(kasoba.Id);
                koeiKasoba++;
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = true;
                teianShisetsuWrap.shisetsuId = kasoba.Id;
                teianShisetsuWrap.shisetsuName = kasoba.Name;
                teianShisetsuWrap.shisetsuKubun = '1:公営(市内)';
                teianShisetsuWrap.shutokenIchibuChiki = kasoba.ShutokenIchibuChiki__c;
                teianShisetsuListWrap.standardKasobaList.add(teianShisetsuWrap);
            }
        }

        for(Shisetsu__c kasoba : kasobaList){
            
            if(teianShisetsuListWrap.standardKasobaList.size() >= 2) break;
            
            if(!chkKasobaDuplicateIdSet.contains(kasoba.Id) && 
                kasoba.KoeiMinei__c != '民営' && 
                kasoba.Shikugun__c != shikugunId && 
                koeiKasoba < 2 && 
                kasoba.Id != 'a0y7F000003BTUa'){ // 西寺尾会堂は除外
                
                chkKasobaDuplicateIdSet.add(kasoba.Id);
                koeiKasoba++;
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = true;
                teianShisetsuWrap.shisetsuId = kasoba.Id;
                teianShisetsuWrap.shisetsuName = kasoba.Name;
                teianShisetsuWrap.shisetsuKubun = '2:公営(市外)';
                teianShisetsuWrap.shutokenIchibuChiki = kasoba.ShutokenIchibuChiki__c;
                teianShisetsuListWrap.standardKasobaList.add(teianShisetsuWrap);
            }
        }

        if(shikugunIdTokyo23KuKasobaMap.containsKey(shikugunId)){
            
            for(Tokyo23KuShisetsuWrap tokyo23KuShisetsuWrap : shikugunIdTokyo23KuKasobaMap.get(shikugunId)){
                if(teianShisetsuListWrap.standardKasobaList.size() >= 2) break;
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = tokyo23KuShisetsuWrap.shisetsuId;
                teianShisetsuWrap.shisetsuName = tokyo23KuShisetsuWrap.shisetsuName;
                teianShisetsuWrap.shisetsuKubun = '2:併設民営';
                teianShisetsuWrap.shutokenIchibuChiki = true;
                teianShisetsuListWrap.standardKasobaList.add(teianShisetsuWrap);
            }
        }
        else{
            
            for(Shisetsu__c kasoba : kasobaList){
                
                if(teianShisetsuListWrap.standardKasobaList.size() >= 2) break;
                
                if(!chkKasobaDuplicateIdSet.contains(kasoba.Id) && 
                    kasoba.KoeiMinei__c == '民営' && 
                    kasoba.Shikugun__c == shikugunId){
                    
                    chkKasobaDuplicateIdSet.add(kasoba.Id);
                    TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                    teianShisetsuWrap.isKasoba = true;
                    teianShisetsuWrap.shisetsuId = kasoba.Id;
                    teianShisetsuWrap.shisetsuName = kasoba.Name;
                    teianShisetsuWrap.shisetsuKubun = '3:民営(市内)';
                    teianShisetsuWrap.shutokenIchibuChiki = kasoba.ShutokenIchibuChiki__c;
                    teianShisetsuListWrap.standardKasobaList.add(teianShisetsuWrap);
                }
            }

            for(Shisetsu__c kasoba : kasobaList){
                
                if(teianShisetsuListWrap.standardKasobaList.size() >= 2) break;
                
                if(!chkKasobaDuplicateIdSet.contains(kasoba.Id) && 
                    kasoba.KoeiMinei__c == '民営' && 
                    kasoba.Shikugun__c != shikugunId){
                    
                    chkKasobaDuplicateIdSet.add(kasoba.Id);
                    TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                    teianShisetsuWrap.isKasoba = true;
                    teianShisetsuWrap.shisetsuId = kasoba.Id;
                    teianShisetsuWrap.shisetsuName = kasoba.Name;
                    teianShisetsuWrap.shisetsuKubun = '4:民営(市外)';
                    teianShisetsuWrap.shutokenIchibuChiki = kasoba.ShutokenIchibuChiki__c;
                    teianShisetsuListWrap.standardKasobaList.add(teianShisetsuWrap);
                }
            }
        }

        Set<Id> daiichiShiminRyokinIdSet = new Set<Id>();
        for(ShiminRyokinTaishoGyoseikuTaishosha__c shiminRyokinTaishoGyoseikuTaishosha : [  select Id, SaijoRef__r.Id 
                                                                                            from ShiminRyokinTaishoGyoseikuTaishosha__c 
                                                                                            where ShikugunRef__c = :shikugunId 
                                                                                                and ShiminRyokinKubun__c = '第一市民料金' 
                                                                                                and SaijoRef__r.ShisetsuKubun__c = '公営' 
                                                                                                and SaijoRef__r.ShokaiKa__c = true ]){
            daiichiShiminRyokinIdSet.add(shiminRyokinTaishoGyoseikuTaishosha.SaijoRef__r.Id);
        }

        for(ShiminRyokinTaishoGyoseikuMoshu__c shiminRyokinTaishoGyoseikuMoshu : [  select Id, SaijoRef__r.Id 
                                                                                    from ShiminRyokinTaishoGyoseikuMoshu__c 
                                                                                    where ShikugunRef__c = :shikugunId 
                                                                                        and ShiminRyokinKubun__c = '第一市民料金' 
                                                                                        and SaijoRef__r.ShisetsuKubun__c = '公営' 
                                                                                        and SaijoRef__r.ShokaiKa__c = true ]){
            daiichiShiminRyokinIdSet.add(shiminRyokinTaishoGyoseikuMoshu.SaijoRef__r.Id);
        }

        List<Saijo__c> saijoList = [select Id, 
                                            Name, 
                                            ShisetsuKubun__c, 
                                            SuishoSaijo__c, 
                                            KasobaHeisetsuList__c, 
                                            ShikugunRef__c, 
                                            HoyuShutaiSogishaJiinRef__c, 
                                            DISTANCE(IdoKedo__c, GEOLOCATION(:shikugunMst.Chiriichijouhou__latitude__s,:shikugunMst.Chiriichijouhou__longitude__s), 'km') dist, 
                                            (
                                                select Id, 
                                                        X1ShiyoRyokinIppan__c, 
                                                        X1ShiyoRyokinShimin__c, 
                                                        X1ShiyoRyokinSonota__c, 
                                                        X2ShiyoRyokinIppan__c, 
                                                        X2ShiyoRyokinShimin__c, 
                                                        X2ShiyoRyokinSonota__c 
                                                from SaijoShikijos__r 
                                            )
                                    from Saijo__c 
                                    where SogishaKensakuHihyoji__c = false 
                                        and ShokaiKa__c = true 
                                        and ShiryoSofuNg__c = false 
                                        and Id != 'a3y2v000000ADbz' // 西寺尾会堂は除外
                                        and (DISTANCE(IdoKedo__c, GEOLOCATION(:shikugunMst.Chiriichijouhou__latitude__s,:shikugunMst.Chiriichijouhou__longitude__s), 'km') < 30 or Id = :daiichiShiminRyokinIdSet) 
                                    order by DISTANCE(IdoKedo__c, GEOLOCATION(:shikugunMst.Chiriichijouhou__latitude__s,:shikugunMst.Chiriichijouhou__longitude__s), 'km') asc NULLS LAST];
        Set<Id> chkSaijoDuplicateIdSet = new Set<Id>();
        Integer saijoKoei = 0;
        for(Saijo__c saijo : saijoList){
            
            if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                daiichiShiminRyokinIdSet.contains(saijo.Id) && 
                saijoKoei < 2){
                
                chkSaijoDuplicateIdSet.add(saijo.Id);
                saijoKoei++;
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = saijo.Id;
                teianShisetsuWrap.shisetsuName = saijo.Name;
                teianShisetsuWrap.shisetsuKubun = '1:公営';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }
        }
        
        if(shikugunIdTokyo23KuSaijoMap.containsKey(shikugunId)){
            
            for(Tokyo23KuShisetsuWrap tokyo23KuShisetsuWrap : shikugunIdTokyo23KuSaijoMap.get(shikugunId)){
                chkSaijoDuplicateIdSet.add(tokyo23KuShisetsuWrap.shisetsuId);
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = tokyo23KuShisetsuWrap.shisetsuId;
                teianShisetsuWrap.shisetsuName = tokyo23KuShisetsuWrap.shisetsuName;
                teianShisetsuWrap.shisetsuKubun = '2:併設民営';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }
        }

        for(Saijo__c saijo : saijoList){
            
            if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                saijo.ShisetsuKubun__c == '自社' && 
                saijoSekoKanoAreaSet.contains(saijo.HoyuShutaiSogishaJiinRef__c) && 
                saijo.ShikugunRef__c == shikugunId && 
                isSaijoRyokinMuryo(saijo)){

                chkSaijoDuplicateIdSet.add(saijo.Id);
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = saijo.Id;
                teianShisetsuWrap.shisetsuName = saijo.Name;
                teianShisetsuWrap.shisetsuKubun = '3:市内自社';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }

            if(teianShisetsuListWrap.standardSaijoList.size() >= 10) return teianShisetsuListWrap;
        }

        if(shikugunIdTokyo23KuSaijoMap.containsKey(shikugunId)){
            
            for(Saijo__c saijo : saijoList){
                if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                    saijo.ShisetsuKubun__c == '自社' && 
                    saijoSekoKanoAreaSet.contains(saijo.HoyuShutaiSogishaJiinRef__c) && 
                    saijo.ShikugunRef__c != shikugunId && 
                    Decimal.valueOf(String.valueOf(saijo.get('dist'))) <= 10 && 
                    isSaijoRyokinMuryo(saijo)){
                    
                    chkSaijoDuplicateIdSet.add(saijo.Id);
                    TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                    teianShisetsuWrap.isKasoba = false;
                    teianShisetsuWrap.shisetsuId = saijo.Id;
                    teianShisetsuWrap.shisetsuName = saijo.Name;
                    teianShisetsuWrap.shisetsuKubun = '3:市外自社';
                    teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
                }

                if(teianShisetsuListWrap.standardSaijoList.size() >= 10) return teianShisetsuListWrap;
            }
        }

        for(Saijo__c saijo : saijoList){
            
            if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                saijo.ShisetsuKubun__c == '民営' && 
                saijo.ShikugunRef__c == shikugunId && 
                saijo.SuishoSaijo__c && 
                saijo.KasobaHeisetsuList__c != '有'){

                chkSaijoDuplicateIdSet.add(saijo.Id);
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = saijo.Id;
                teianShisetsuWrap.shisetsuName = saijo.Name;
                teianShisetsuWrap.shisetsuKubun = '4:推奨民営';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }

            if(teianShisetsuListWrap.standardSaijoList.size() >= 10) return teianShisetsuListWrap;
        }

        for(Saijo__c saijo : saijoList){
            
            if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                saijo.ShisetsuKubun__c == '自社' && 
                saijoSekoKanoAreaSet.contains(saijo.HoyuShutaiSogishaJiinRef__c) && 
                saijo.ShikugunRef__c != shikugunId && 
                isSaijoRyokinMuryo(saijo)){

                chkSaijoDuplicateIdSet.add(saijo.Id);
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = saijo.Id;
                teianShisetsuWrap.shisetsuName = saijo.Name;
                teianShisetsuWrap.shisetsuKubun = '5:市外自社';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }

            if(teianShisetsuListWrap.standardSaijoList.size() >= 10) return teianShisetsuListWrap;
        }

        for(Saijo__c saijo : saijoList){
            
            if(!chkSaijoDuplicateIdSet.contains(saijo.Id) && 
                (saijo.ShisetsuKubun__c == '寺院' || saijo.ShisetsuKubun__c == '寺院（本堂のみ）') && 
                saijo.ShikugunRef__c == shikugunId && 
                saijo.SuishoSaijo__c){
                
                chkSaijoDuplicateIdSet.add(saijo.Id);
                TeianShisetsuWrap teianShisetsuWrap = new TeianShisetsuWrap();
                teianShisetsuWrap.isKasoba = false;
                teianShisetsuWrap.shisetsuId = saijo.Id;
                teianShisetsuWrap.shisetsuName = saijo.Name;
                teianShisetsuWrap.shisetsuKubun = '6:推奨寺院';
                teianShisetsuListWrap.standardSaijoList.add(teianShisetsuWrap);
            }

            if(teianShisetsuListWrap.standardSaijoList.size() >= 10) return teianShisetsuListWrap;
        }

        return teianShisetsuListWrap;
    }

    private static Boolean isSaijoRyokinMuryo(Saijo__c theSaijo){

        if(theSaijo.SaijoShikijos__r.size() == 0) return true;
        
        Boolean isMuryo = true;
        for(SaijoHall__c theSaijoHall : theSaijo.SaijoShikijos__r){
            if(theSaijoHall.X1ShiyoRyokinIppan__c != null && theSaijoHall.X1ShiyoRyokinIppan__c > 0 ) return false;
            if(theSaijoHall.X1ShiyoRyokinShimin__c != null && theSaijoHall.X1ShiyoRyokinShimin__c > 0 ) return false;
            if(theSaijoHall.X1ShiyoRyokinSonota__c != null && theSaijoHall.X1ShiyoRyokinSonota__c > 0 ) return false;
            if(theSaijoHall.X2ShiyoRyokinIppan__c != null && theSaijoHall.X2ShiyoRyokinIppan__c > 0 ) return false;
            if(theSaijoHall.X2ShiyoRyokinShimin__c != null && theSaijoHall.X2ShiyoRyokinShimin__c > 0 ) return false;
            if(theSaijoHall.X2ShiyoRyokinSonota__c != null && theSaijoHall.X2ShiyoRyokinSonota__c > 0 ) return false;
        }

        return true;
    }
}