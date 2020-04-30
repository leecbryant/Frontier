//
//  FeatureListScreen.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

protocol PassEditToHorse {
    func editPassBack(response: Bool)
}

class EditHorse: UIViewController, CanRecieve {
    // Base horse information
    var BaseHorseData: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var filteredBands: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var HorseData = NameBandHerd(ID: 0, Name: "", herd: "", bands: "", Status: "")
    // Horse Picture Information
    var HorseImageData: HorsePhotos = HorsePhotos(data: [Photo]())
    var imageArray = [Photo]()
    // Horse Dart Information
    var HorseLedger:HorseTreatments = HorseTreatments(data: [Treatment]())
    var HorseDartData = [Treatment]()
    // Horse Attribute Information
    var HorseAttributes: HorseMarkings = HorseMarkings(data: [Marking]())
    var HorseMarkingData = Marking(HorseID: 0, color: "", Position: nil, Mane_Color: nil, LFMarking: nil, RFMarking: nil, LHMarking: nil, RHMarking: nil, FaceString: nil)
    
    // Other Declerations
    var activityView: UIActivityIndicatorView?
    var delegate: PassEditToHorse?
    var selectedFeatures = Features(Color: [], Mane: [], ManePosition: [], Face: [], Whorl: [], rightFront: [], rightBack: [], leftFront: [], leftBack: [])
    
    // Random Name Array, should be DB in future - Should also be split into 2 arrays, first name last name. (JUST PROOF OF CONCEPT)
    var NameArray: [String] = ["Lester Sauls","Coral Timmins","Tijuana Granier","Charley Oboyle","Pura Demaria","Mireya Lamantia","Gwyn Hehn","Annamarie Caudle","Gene Medrano","Salley Hiller","Ching Oneal","Jeremy Penner","Beckie Scheider","Jordon Laverdiere","Shu Chavera","Minda Outen","Doris Schweiger","Roseanna Mccumber","Vera Chaplin","Quiana Stamey","Thad Payton","Minna Lauderdale","Ashley Weisz","Roma Elliston","Cayla Brwon","Ava Mcconnaughey","Jeramy Ormand","Garnett Hetzler","Piper Edlund","Randal Lake","Arielle Lino","Cleveland Saville","Soila Poyner","Tami Coyne","Michaele Wicks","Eun Lindeman","Sheron Steves","Maxwell Novello","Tracee Ploss","Serena Stembridge","Florine Riemer","Shila Maxfield","Julio Strausbaugh","Mui Santoro","Kelsi Li","Alena Medford","Ward Vanorden","Sal Heideman","Marylyn Theurer","Loreta Bianchi","Trinidad Melnyk","Season Keane","Rudolph Minnich","Rocky Coppedge","Karrie Stumbo","Toya Brassfield","Rhea Chavis","Kieth Carbonneau","Savanna Hynson","Alvin Vargo","Shavonne Blackstone","Lorna Morabito","Claudine Ruley","Theda Rollison","Catarina Cloutier","Hui Buel","Melody Debo","Taryn Marland","Rufus Gleaton","Daina Oles","Cami Cron","Veola Kibble","Apryl Muma","Teisha Stonecipher","Jana Kincade","Zonia Mcandrew","Carlota Fairey","Bea Calero","Liberty Kuiper","Marni Deese","Lakiesha Mona","Trish Seidl","Maryrose Senior","Suanne Schow","Louis Worsham","Soledad Walson","Murray Copland","Tyrone Mathes","Mira Hoard","Amira Braddock","Analisa Macon","Augustus Dingler","Tamra Matsumura","Kiyoko Trotman","Son Knick","Tisa Yamashiro","Olga Roberie","Billy Catledge","Melissia Taber","Sharda Maddock","Nakia Foltz","Donn Trundy","Kanisha Strayer","Ayana Landaverde","Youlanda Bibbs","Shantae Mcduffee","Nida Ruble","Zetta Owens","Dalila Cianci","Alejandrina Heim","Brant Volk","Kimi Roache","Ivory Burgett","Laree Barton","Jacquelin Stratman","Gertrude Cabello","Milagro Sitsler","Paulette Rance","Mei Vise","Tracy Gust","Danille Dominick","Opal Saez","Carmel Mccaskill","Ailene Hakala","Tanna Strosnider","Altagracia Ivey","Carmelina Wohlgemuth","Vida Knepp","Kanesha Bilger","Anya Vroman","Britta Kulinski","Nereida Bernhardt","Enola Mcculloch","Latanya Stell","Willian Kingrey","Mitchell Gentner","Percy Hose","Gerardo Becton","Hayley Avent","Milan Marie","Angeline Olsson","Estrella Merkle","Jenine Trapani","Shawn Nugent","Ilda Churchill","Louella Peet","Clark Westbrook","Melodi Crume","Xiomara Mango","Page Mulherin","Machelle Janelle","Eric Towner","Lavenia Wydra","Manda Zepeda","Fern Carrigan","Melonie Wooding","Charmain Stam","Summer Beets","Demetria York","Rich Hoffer","Darrin Zermeno","Jeffrey Vandyne","Edda Bragg","Yelena Hazeltine","Sona Stoner","Cristen Brew","Emory Whittenburg","Brenton Cheatwood","Tosha Danielsen","Jong Archey","Dara Tourigny","Denae Zachary","Renna Stoneburner","Lindsay Mazzariello","Mariette Valliere","Ada Hardge","Phylicia Eury","Neida Lovern","Twanna Nunemaker","Rema Fincher","Isaac Varela","Emilie Water","Abigail Pool","Macie Wrinkle","Alleen Dorrance","Venetta Tupper","Mary Castleberry","Effie Segers","Oralee Zook","Sha Linsley","Sandi Aviles","Maris Lewellyn","Yon Tillman","Svetlana Hamlett","Suzann Clower","Marin Bamber","Leisa Garrido","Annett Gardiner","Jaleesa Palmieri","Dane Grieves","Albertine Vaz","Sung Kuta","Kortney Regalado","Quinn Kloss","Ronna Bove","Misty Dinger","Janyce Abernethy","Thomasina Hooton","Calista Courser","Darcel Westerberg","Teofila Paisley","Dannette Torina","Jonah Heger","Angelena Hulsey","Raymon Mattice","Harriett Touchette","Bernarda Crandle","Peggy Razo","Dorathy Witherow","Renita Galeano","Jenice Gallogly","Dorie Davids","Kiley Peach","Rashad Soltys","Cindie Curtiss","Jacquelynn Satterfield","Maryln Caskey","Frederick Stamand","Patrice Tiemann","Raquel Bridwell","Tanika Wohlwend","Ricardo Fava","Majorie Arline","Regan Hoggard","Shelby Tatem","Georgia Hunton","Hunter Langlinais","Rafael Pocock","Fabiola Tegeler","Agueda Entrekin","Rosalyn Luo","Verna Waller","Eleanore Faler","Judie Cuenca","Nicol Meacham","Phuong Ary","Babara Digennaro","Gustavo Bear","Golda Gonsoulin","Trey Pittsley","Jama Vinson","Carline Bonet","Marjory Tews","Arleen Bobadilla","Johnny Kott","Pete Compton","Junior Ota","Ilana Bastien","Tiffany Derouin","Glennis Smeltzer","Hee Acoff","Anneliese Bottorff","Dayna Babineau","Tess Rodd","Rolland Vandenburg","Karole Pridgen","Marilynn Knowlton","Rosalba Lash","Mavis Schwab","Luther Fahnestock","Emely Eisenman","Evelia Rutland","Alverta Tusing","Kristi Santacruz","Tuyet Tenenbaum","Katharina Friedland","Brian Rundell","Luella Whipps","Bradley Sommers","Grover Ambrosino","Margene Fox","Carter Lesesne","Otto Kingsbury","Wilburn Victorino","Adina Maza","Marietta Shield","Eloise Noblin","Dede Hoff","Sol Petroff","Nelson Stoltz","Lucretia Marlowe","Madonna Mui","Thalia Sollars","Myung Soucie","Shaquana Mclelland","Arianne Walton","Kathryne Wixon","Lelah Slane","Karey Jelks","Terese Horak","Dale Holleran","Dionna Carrico","Eldora Berquist","Jeri Vandergriff","Becky Ngo","Lynnette Lucio","Refugia Casavant","Ouida Rabon","Booker Hopple","Cristi Gander","Marcene Montandon","Vertie Maharaj","Lynwood Pass","Genevie Lamark","Dong Maher","Christian Lussier","Sabrina Flaherty","Dianne Mumford","Georgiana Delvalle","Helene Shepler","Mozelle Henningsen","Michael Clutts","Colene Hampton","Ivette Thurber","Demetrice Albury","Georgianna Gabriel","Amparo Swords","Jamal Galbraith","Huey Yearby","Nell Hanneman","Jacquline Bruns","Conrad Mccourt","Theresia Abila","Liliana Harte","Maile Tropea","Jennefer Kok","Sterling Crowder","Senaida Spector","Denis Patrick","Boris Wilmes","Alycia Albus","Marleen Roepke","Dodie Nguyen","Corine Sue","Sommer Madding","Syble Hegarty","Graig Weidler","Gema Petties","Krystle Lira","Ruthie Worley","Jazmine Grisson","Calandra Mincks","Taunya Dearmond","Giuseppina Kerr","Lilian Leite","Tandy Mandell","Lahoma Dunaway","Jestine Eaves","Rickie Monier","Alona Quast","Cristy Lebleu","Skye Shepley","Floyd Biggers","Lolita Swinson","Alethia Herrick","Michal Lyden","Alane Shadley","Lorean Bidwell","Ali Esposito","Elvia Whitt","Lea Treese","Lucie Burbage","Roxana Stringham","Keren Olesen","Lizzette Theroux","Asia Bonnell","Sophie Hank","Joanie Loeb","Irina Zurita","Claribel Farnsworth","Floy Binger","Sue Spier","Trudi Diana","Rona Galligan","Carylon Paniagua","Caroyln Birnbaum","Ewa Yopp","Saul Corpus","Marilyn Pouncy","Christiana Mcburney","Xochitl Colwell","Saturnina Greb","Cira Abele","Marlo Rivers","Madelene Dearth","Fe Dewar","Lavon Suddeth","Justina Mari","Glayds Points","Josephina Borba","Stephenie Hemingway","Arnoldo Thresher","Josefa Powley","Imelda Tomblin","Kizzy Fandel","Annabel Topham","Jamika Abbott","Lashawna Burget","Lang Orellana","Angeles Glascock","Bridget Thies","Alysia Dieguez","Ivelisse Youngman","Bambi Cranfield","Zofia Homeyer","Hye Theriot","Darlene Gully","Melida Mcquade","Winford Thor","Rhiannon Sosnowski","Janessa Pelzer","Wai Burg","Bell Lofland","Avril Bonney","Rachell Sapp","Mercedes Flewelling","Fausto Thiem","Jenelle Stonge","Argentina Lui","Kayleigh Mcelhaney","Quinton Sable","Magaly Swiderski","Merrilee Storlie","Yasmin Loop","Rodney Durante","Catrina Helm","Corey Mayhan","Sonny Rhoton","Tanja Bissette","Chara Mera","Berna Ehrmann","Maryland Uren","Chantay Abramowitz","Tennille Gilliam","Elois Sager","Alonso Mansur","Rosaura Doverspike","Rosa Manigault","Orpha Silvernail","Nakita Segars","Bunny Sutera","Otis Tack","Drucilla Kegley","Kazuko Scholz","Ardella Flanery","Jeniffer Podkowka","Pedro Boyette","Pinkie Scot","Doreen Tinney","Alesha Fitts","Devorah Hickox","Genoveva Stinebaugh","Demetra Egger","Aleen Hildebrant","Kristan Henthorn","Georgie Goll","Lien Gribble","Bessie Wendler","Daisy Dorrell","Johnie Tarpey","Leslie Lanford","Hisako Snook","Tyler Klar","Mayola Heckart","Maynard Zulauf","Alexandria Klingensmith","Lavina Kolbe","Kecia Dollard","Wan Guild","Migdalia Rose","Mckenzie Rozell","Sadye Tussey","Ingeborg Tarry","Lloyd Erne","Ira Vankleeck","Glendora Firth","Yee Vaca","Glinda Skeen","Dierdre Thornsberry","Era Mao","Hipolito Marrin","Joline Hoyle","Maragret Bruno","Carley Burling","Tynisha Deck","Gilma Huynh","Eulah Wehling","Heather Cordero","Nelida Braggs","Micaela Carter","Nadia Parfait","Lyndsay Tarvin","Milo Joslyn","Yuette Dower","Jeane Poplar","Carey Yost","Apolonia Cool","Delena Witter","Hyo Barnett","Fiona Merrihew","Latoyia Lozada","Emerson Lamagna","Muriel Yarnall","Kraig Treaster","Bethann Habib","Velvet Augustine","Grant Laurich","Patrica Stille","Claud Mcintyre","Archie Balla","Reid Prisbrey","Lonnie Kapoor","Sanford Blanco","Romaine Knupp","Kit Segraves","Bailey Fiske","Simone Fellows","Virgen Whitehorn","Jacquelyn Won","Jenette Vermillion","Queenie Marcucci","Alton Doucette","Garnet Chou","Sheila Donoho","Adrianna Fein","Santiago Drees","Deanna Zheng","Wanetta Wittrock","Luana Chewning","Barbera Atha","Mayra Frank","Pearlene Brazel","Kacie Sanfilippo","Brandie Marson","Edith Estep","Valarie Eppinger","Melinda Mastronardi","Jonie Bever","Alec Perrino","Meridith Manjarrez","Johnette Pappan","Lavern Burgio","Sally Serafini","Jettie Jenkin","Yuko Luu","Ossie Comfort","Katia Benzel","Niesha Ocheltree","Grace Strong","Robena Spanbauer","Ariane Critchfield","Gaynell Shane","Siu Claybrook","Willa Faulcon","Clemencia Cornwell","Hallie Heer","Shanelle Coday","Shay Lightle","Kerri Claywell","Genia Fleagle","William Ayala","Ethel Brazzell","Talia Stake","Gay Cristobal","Ahmed Seyal","Trena Gilley","Eryn Shuck","Luigi Ferrari","Faye Mattei","Sharri Plata","Robert Lovely","Lorena Muntz","Denice Mcie","Marco Maes","Iona Bertolino","Lona Hannaman","Grayce Drum","Carmon Lucero","Sharon Fackler","France Burritt","Humberto Glasser","Genaro Hartig","Jillian Duquette","Latarsha Pettigrew","Alyce Petrey","Raelene Cotta","Elma Mcneal","Vernice Middleton","Brandee Minks","Treena Pinheiro","Rachelle Crandall","Lori Borgeson","Richelle Whitcher","Yajaira Bassi","Lurlene Golay","Jerome Schommer","Evelina Mcelveen","Cheryll Glickman","Tara Mings","Cori Padillo","Derrick Preston","Chung Hovland","Jeremiah Tay","Sheena Rioux","Allyn Yankey","Maximina Salas","Jani Huber","Shalonda Hulin","Kathleen Bellon","Kate Bundrick","Salvatore Bussey","Loren Hickman","Cinda Heidecker","Toshiko Bednarz","Alla Prejean","Melisa Lobel","Romona Pottinger","Vashti Jeppesen","Carissa Birchfield","Marilu Marable","Marshall Leggett","Debra Bullins","Hal Timlin","Andreas Conforti","Alysha Hoehne","Kathlyn Correa","Jewell Gunning","Camila Lant","Katelynn Parkison","Patrick Tietz","Darby Hebron","Alesia Larrimore","Gloria Edmisten","Deandra Melendrez","Roseanne Lamprecht","Nadene Arneson","Felisa Macke","Barbie Repass","Shanda Euell","Jon Schacht","Lorretta Adamczyk","Ricarda Brazil","Mignon Mattison","Imogene Kruse","Milissa Schmid","Von Keesler","Dagmar Finks","Glennie Creek","Miyoko Saechao","Christene Weinstock","Buster Lawhead","Franchesca Bumpers","Kimberley Brungardt","Karla Fountain","Errol Aten","Julianne Selden","Shondra Stradford","Mellisa Nord","Bryant Berrios","Christopher Peirce","Velva Mcvicker","Kaila Degree","Nanci Piatt","Kamala Cranfill","Classie Losada","Epifania Curatolo","Patricia Lacross","Tamar Heasley","Rochelle Manzano","Joyce Riner","Ethyl Aziz","Tatum Barthel","Micheline Gaumer","Ralph Lamkin","Jolyn Hintze","Joann Cobbley","David Duplantis","Shawana Kropf","Sana Licht","Lyle Hecht","Lane Vos","Lin Galvan","Lola Carneal","Ute Tarrance","Christine Barbara","Londa Branning","Julieta Scuderi","Ngan Bolling","Ashanti Bohannan","Charisse Dubuque","Annie Schepis","Lida Pereyra","Mike Valenzuela","Kami Poulin","Kirk Lafuente","Krista Greggs","Xavier Spinks","Sharonda Rodney","Tu Baca","Sau Stwart","Elisa Revel","Johnnie Hoggan","Margarette Standifer","Santa Sisneros","Adeline Nunnally","Meggan Faries","Noreen Worthey","Lauralee Kennan","Loraine Janousek","Kristie Mends","Cortney Pidgeon","Karl Bohling","Vennie Cusick","Elvina Mass","Marna Rios","Ronny Carpio","Roosevelt Solorzano","Marceline Lavery","Maricela Baber","Johanna Sliter","Virgie Guse","Meg Fuell","Lala Portalatin","Valorie Clemmons","Lanita Trollinger","Garry Ben","Fermin Najarro","Pamula Mumme","Ayanna Toussaint","Tiera Marmolejo","Lanora Pitcher","Verena Nierman","Vina Chastain","Ernie Rorick","Jung Rambo","Leana Zorn","Terrance Czerwinski","Odelia Overstreet","Golden Perillo","Terry Brobst","Marchelle Nickles","Douglas Stricklin","Robby Ifill","Silva Tichenor","Shalanda Strang","Aleta Mcivor","Lennie Stanbery","Sindy Witmer","Lauryn Bigby","Larisa Burciaga","Ora Andrada","Nenita Sirianni","Burton Majka","Rosie Holleman","Tonisha Vandenbosch","Karlyn Wedell","Fletcher Aron","Dorris Straughter","Elliot Farrow","Edmond Boyett","Ulysses Hudkins","Lavette Sievert","Edgar Wasserman","Eugenio Schoenberger","Izola Gebhard","Shaneka Parshall","Marnie Harari","Margery Markland","Ina Pippins","Barrie Chun","Raymundo Pew","Azalee Hiler","Fredric Wilcox","Oretha Nau","Keesha Wensel","Renea Clemens","Araceli Upson","Andrea Gearheart","Jada Strawser","Malena Fritch","Emerita Hagberg","Tien Hyndman","Lawrence Yelton","Beryl Plunkett","Joey Kelso","Kyra Dipaola","Cecile Wurth","Nieves Byrom","Herman Royce","Yessenia Dolby","Jacinta Cirillo","Phung Weingartner","Jan Booher","Sasha Pesina","Ima Bennette","Jeffery Wickline","Mittie Atherton","Karolyn Bona","Dulce Roehl","Avis Pintor","Lannie Amedee","Leota Herdman","Terence Hirsh","Elena Roca","Cyndy Kimbell","Albertina Crutchfield","Jasmin Keeth","Zachery Barfield","Kimbery Weeks","Merrie Marten","Tiara Lewison","Merlene Acquaviva","Mee Reif","Marcelo Sprvill","Melvin Hickson","Giovanna Koepsell","Janie Oniel","Marcus Greve","Wilford Vigo","Jarred Sirmons","Nevada Kennell","Rosena Bobo","Lawerence Holmen","Nubia Wilt","Sueann Winfree","Newton Brimage","Helga Haan","Blair Parrett","Felice Dease","Lynne Stokes","Blondell Blatt","Sulema Ohl","Bong Bainter","Audry Waldschmidt","Natisha Dewolfe","Lionel Bybee","Halina Brackin","Megan Wanamaker","Melany Knabe","Lorrine Epperson","Justine Galang","Renaldo Petrella","Leeanna Southall","Krishna Edgerly","Phylis Dibella","Nadine Trainor","Dakota Gillan","Jonell Dubreuil","Lorina Hagemeier","Laine Nodal","Dana Auld","Michaela Straka","Kourtney Masden","Clair Beno","Lucy Otter","Kristeen Madera","Katelin Chung","Lavinia Urbain","Kam Luciano","Kimiko Drapeau","Jacquelyne Millsap","Carrie Guidroz","Numbers Vanderveen","Nolan Yeates","Marlin Fearon","Loree Hensler","Rosenda Marc","Deloris Sanluis","Ellsworth Zuchowski","Earlean Ackley","Marianela Ficklin","Shari Rolland","Marianna Wrona","Magdalena Munns","Bonny Jahn","Tommie Rousseau","Kristal Walczak","Evita Campoverde","Maire Bollin","Gaylene Macarthur","Aracely Troncoso","Kellee Sottile","Pei Mumper","Magnolia Crispin","Euna Wollard","Laurine Filler","Paul Brimmer","Carolee Biller","Rashida Minaya","Carri Wible","Lakita Demming","Caron Armagost","Wendi Mascia","Desiree Borja","Olivia Risner","Mana Rivard","Ermelinda Madia","Teri Nagle","Tanya Baskerville","Ervin Huard","Ashely Lebel","Jaqueline Grayer","Latoria Seigel","Sarita Yeoman","Mazie Cornelius","Krystal Kivi","Elaina San","Leonel Parisi","Elnora Bentler","Ernest Bonnett","Jule Desanti","Deetta Higham","Shayne Glisson","Wenona Caliendo","Vanessa Hallowell","Zulema Polley","Seema Workman","Nery Wehr","Veda Agee","Freda Yarger","Ester Fonda","Junie Blahnik","Tessa Juhl","Catrice Dougherty","Adelaida Formica","Brenna Ledger","Stefani Criner","Domitila Luhman","Crystal Roff","Racquel Lanser","Barbar Dinsmore","Daniele Mayon","Ena Tavarez","Tory Barnwell","Russell Kunkel","Levi Bratcher","Setsuko Facio","Wayne Barcus","Kent Repka","Burma Pontiff","Claretta Stalnaker","Albertha Trotta","Mirta Almeida","Rickey Nakashima","Faith Phu","Shelba Kaczynski","Gracie Abercrombie","Justin Decuir","In Light","Malcolm Hasler","Maryetta Pitchford","Del Maines","Irvin Wroblewski","Annamae Eddie","Elinor Saenz","Zachariah Lemay","Latashia Thomson","Tangela Jacko","Jaunita Scates","Zena Jaworski","Dianna Hosch","Herb Seaborn","Salina Ashalintubbi","Jerrica Steiger","Latoya Siggers","Sidney Zimmermann","Natalya Gilmartin","Truman Calcagno","Bertha Rohman","Verlene Picou","Herta Pollard","Asha Kovacs","Martin Lema","Foster Furguson","Tawna Battles","Caren Lamothe","Craig Fallin","Myrtle Erwin","Lance Timmons","Carlena Wenner","Floretta Sheats","Cordell Rapoza","Tyra Wheeless","Antonia Shubert","Nancy Angell","Cassaundra Buster","Gregg Swaby","Nickie Mcgavock","Marcell Amerine","Cierra Alberts","Lynn Duchesne"];
    
    func passDataBack(currFeature: String, data: [String]) {
        switch currFeature {
            case "color":
                colorFeatures = data
            case "mane":
                maneFeatures = data
            case "maneposition":
                manePositionFeatures = data
            case "face":
                faceFeatures = data
            case "whorl":
                whorlFeatures = data
            case "rfFeet":
                rfFeetFeatures = data
            case "rrFeet":
                rrFeetFeatures = data
            case "lfFeet":
                lfFeetFeatures = data
            case "lrFeet":
                lrFeetFeatures = data
                
            default:
                print("Error: invalid feature selection passback")
        }
        self.tableView.reloadData()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Band: UITextField!
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var BandSwitch: UISwitch!
    
    
    var backButton : UIBarButtonItem!

    var features: [Feature] = []
    var selectedFeature = ""
    
    var colorFeatures: [String] = []
    var maneFeatures: [String] = []
    var manePositionFeatures: [String] = []
    var faceFeatures: [String] = []
    var whorlFeatures: [String] = []
    var rfFeetFeatures: [String] = []
    var rrFeetFeatures: [String] = []
    var lfFeetFeatures: [String] = []
    var lrFeetFeatures: [String] = []
    
    override func viewDidLoad() {
        navigationItem.title = "Edit Horse"
        
        Name.text = HorseData.Name
        Band.text = HorseData.bands
        Location.text = HorseData.herd
        BandSwitch.isOn = HorseData.Status == "S" ? true : false
        
        super.viewDidLoad()
        
        colorFeatures = [""+HorseMarkingData.color+""]
        let ManeColor = HorseMarkingData.Mane_Color ?? ""
        maneFeatures = [""+ManeColor+""]
        let Position = HorseMarkingData.Position ?? ""
        manePositionFeatures = [""+Position+""]
        let Face = HorseMarkingData.FaceString ?? ""
        faceFeatures = [""+Face+""]
//        whorlFeatures = [""+HorseMarkingData.!+""]
        let rfMarking = HorseMarkingData.RFMarking == nil ? "" : HorseMarkingData.RFMarking
        rfFeetFeatures = [""+rfMarking!+""]
        let rrMarking = HorseMarkingData.RHMarking ?? ""
        rrFeetFeatures = [""+rrMarking+""]
        let lfMarking = HorseMarkingData.LFMarking ?? ""
        lfFeetFeatures = [""+lfMarking+""]
        let lhMarking = HorseMarkingData.LHMarking ?? ""
        lrFeetFeatures = [""+lhMarking+""]
        
        features = createArray()
        
        
        // Back Button setup
        self.backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func createArray() -> [Feature] {
        var tempFeatures: [Feature] = []
        
        let feature1 = Feature(image: UIImage(named:"color")! ,title: "Color",  selection: "")
        let feature2 = Feature(image: UIImage(named:"mane")! ,title: "Mane",  selection: "")
        let feature3 = Feature(image: UIImage(named:"mane")! ,title: "Mane Position",  selection: "")
        let feature4 = Feature(image: UIImage(named:"face")! ,title: "Face",  selection: "")
        let feature5 = Feature(image: UIImage(named:"feet")! ,title: "Right Front",  selection: "")
        let feature6 = Feature(image: UIImage(named:"feet")! ,title: "Right Rear",  selection: "")
        let feature7 = Feature(image: UIImage(named:"feet")! ,title: "Left Front",  selection: "")
        let feature8 = Feature(image: UIImage(named:"feet")! ,title: "Left Rear",  selection: "")
        tempFeatures.append(feature1)
        tempFeatures.append(feature2)
        tempFeatures.append(feature3)
        tempFeatures.append(feature4)
        tempFeatures.append(feature5)
        tempFeatures.append(feature6)
        tempFeatures.append(feature7)
        tempFeatures.append(feature8)
        
        return tempFeatures
    }
    
    
    @objc func goBack(sender: UIBarButtonItem) {
        let count = colorFeatures.count + maneFeatures.count + manePositionFeatures.count +
        faceFeatures.count + whorlFeatures.count +
        rfFeetFeatures.count + rrFeetFeatures.count +
        lfFeetFeatures.count + lrFeetFeatures.count
        if(count > 0) {
            let refreshAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel? All unsaved selections will be lost.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
            }))

            present(refreshAlert, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let secondVC = segue.destination as! ViewController
           secondVC.currFeature = selectedFeature
           
           switch selectedFeature {
               case "color":
                   secondVC.data = colorFeatures
               case "mane":
                   secondVC.data = maneFeatures
               case "maneposition":
                    secondVC.data = manePositionFeatures
               case "face":
                   secondVC.data = faceFeatures
               case "whorl":
                   secondVC.data = whorlFeatures
               case "rfFeet":
                   secondVC.data = rfFeetFeatures
               case "rrFeet":
                   secondVC.data = rrFeetFeatures
               case "lfFeet":
                   secondVC.data = lfFeetFeatures
               case "lrFeet":
                   secondVC.data = lrFeetFeatures
               default:
                   print("Error: transfering saved features to collection view")
               
           }
           
           
           secondVC.delegate = self
       }
       
       @IBAction func onSubmit(_ sender: Any) {
        struct SubmitFeatures: Codable {
            var Color: String?
            var Mane: String?
            var ManePosition: String?
            var Whorl: String?
            var Face: String?
            var rightFront: String?
            var rightBack: String?
            var leftFront: String?
            var leftBack: String?
        }
        let selectedFeatures =
            SubmitFeatures(
                Color: colorFeatures.count > 0 ? colorFeatures[0] == "" ? nil : colorFeatures[0] : nil,
                Mane: maneFeatures.count > 0 ? maneFeatures[0] == "" ? nil : maneFeatures[0] : nil,
                ManePosition: manePositionFeatures.count > 0 ? manePositionFeatures[0] == "" ? nil : manePositionFeatures[0] : nil,
                Whorl: whorlFeatures.count > 0 ? whorlFeatures[0] == "" ? nil : whorlFeatures[0]  : nil,
                Face: faceFeatures.count > 0 ? faceFeatures[0] == "" ? nil : faceFeatures[0] : nil,
                rightFront: rfFeetFeatures.count > 0 ? rfFeetFeatures[0] == "" ? nil : rfFeetFeatures[0] : nil,
                rightBack: rrFeetFeatures.count > 0 ? rrFeetFeatures[0] == "" ? nil : rrFeetFeatures[0]  : nil,
                leftFront: lfFeetFeatures.count > 0 ? lfFeetFeatures[0] == "" ? nil : lfFeetFeatures[0] : nil,
                leftBack: lrFeetFeatures.count > 0 ? lrFeetFeatures[0] == "" ? nil : lrFeetFeatures[0]  : nil)
        
        struct SubmitObj: Codable {
            var HorseID: Int?
            var Name: String?
            var BandName: String?
            var Location: String?
            var Status: String?
            var Features: SubmitFeatures
        }
        
        let submit = SubmitObj(HorseID: HorseData.ID, Name: Name.text, BandName: Band.text, Location: Location.text, Status: BandSwitch.isOn ? "S" : "M", Features: selectedFeatures)
        
        if Name.text == "" || Band.text == "" || Location.text == "" {
            createAlert(title: "Error", message: "Name, Band, and Location must be filled out.")
        } else if colorFeatures.count > 0 {
            // Stop everything to load
            UIApplication.shared.beginIgnoringInteractionEvents()
            showActivityIndicator()
            // Data Structs
            struct ReturnModel: Codable {
                var success: Bool?
            }
            // Begin Call
            let url = URL(string: Constants.config.apiLink + "api/base/horses")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONEncoder().encode(submit)
            request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    guard let data = data else {return}
                    do {
                         let todoItemModel = try JSONDecoder().decode(ReturnModel.self, from: data)
                            DispatchQueue.main.async {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.hideActivityIndicator()
                                if todoItemModel.success == false {
                                    self.createAlert(title: "Error", message: "Unable to create new horse record")
                                } else {
                                    self.delegate?.editPassBack(response: todoItemModel.success ?? false)
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                    } catch let jsonErr {
                        print(jsonErr)
                   }
             
            }
            task.resume()
        } else {
            createAlert(title: "Error", message: "Horse color must be selected.")
        }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView()
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func Randomize(_ sender: Any) {
        Name.text = NameArray[Int.random(in: 0..<999)];
    }
    
}

extension EditHorse: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feature = features[indexPath.row]
        
        let currFeature = feature.title
        
        switch currFeature {
                case "Color":
                    if colorFeatures.count != 0 {
                        if colorFeatures.count == 1 {
                            feature.selection = colorFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Mane":
                    if maneFeatures.count != 0{
                        if maneFeatures.count == 1 {
                            feature.selection = maneFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Mane Position":
                    if manePositionFeatures.count != 0{
                        if manePositionFeatures.count == 1 {
                            feature.selection = manePositionFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Face":
                    if faceFeatures.count != 0{
                        if faceFeatures.count == 1 {
                            feature.selection = faceFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Whorl":
                    if whorlFeatures.count != 0{
                        if whorlFeatures.count == 1 {
                            feature.selection = whorlFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Right Front":
                    if rfFeetFeatures.count != 0{
                        if rfFeetFeatures.count == 1 {
                            feature.selection = rfFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Right Rear":
                    if rrFeetFeatures.count != 0{
                        if rrFeetFeatures.count == 1 {
                            feature.selection = rrFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Left Front":
                    if lfFeetFeatures.count != 0{
                        if lfFeetFeatures.count == 1 {
                            feature.selection = lfFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Left Rear":
                    if lrFeetFeatures.count != 0{
                        if lrFeetFeatures.count == 1 {
                            feature.selection = lrFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                default:
                    print("Error: selecting a row from feature table")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell") as! FeatureCell
        cell.setFeature(feature: feature)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let myTableSelection = features[indexPath.row].title
       
        
        // If table cell clicked was Color, segue into the Color-picker view
        switch myTableSelection {
            
            case "Color":
                selectedFeature = "color"
            case "Mane":
                selectedFeature = "mane"
            case "Mane Position":
                selectedFeature = "maneposition"
            case "Face":
                selectedFeature = "face"
            case "Whorl":
                selectedFeature = "whorl"
            case "Right Front":
                selectedFeature = "rfFeet"
            case "Right Rear":
                selectedFeature = "rrFeet"
            case "Left Front":
                selectedFeature = "lfFeet"
            case "Left Rear":
                selectedFeature = "lrFeet"
            default:
                print("Error: selecting a row from feature table")
            
        }
        
        performSegue(withIdentifier: "showSelect", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Clear") {
            (action, view, success) in
            self.clearCell(Index: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Clear") {
            (action, view, success) in
            self.clearCell(Index: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])

    }
    
    func clearCell(Index: Int?) {
        let myTableSelection = features[Index ?? 0].title
        
        switch myTableSelection {
             
             case "Color":
                colorFeatures.removeAll()
                selectedFeature = ""
             case "Mane":
                maneFeatures.removeAll()
                selectedFeature = ""
            case "ManePosition":
                manePositionFeatures.removeAll()
                selectedFeature = ""
             case "Face":
                faceFeatures.removeAll()
                selectedFeature = ""
             case "Whorl":
                whorlFeatures.removeAll()
                selectedFeature = ""
             case "Right Front":
                rfFeetFeatures.removeAll()
                selectedFeature = ""
             case "Right Rear":
                rrFeetFeatures.removeAll()
                selectedFeature = ""
             case "Left Front":
                lfFeetFeatures.removeAll()
                selectedFeature = ""
             case "Left Rear":
                lrFeetFeatures.removeAll()
                selectedFeature = ""
             default:
                 print("Error: selecting a row from feature table")
             
         }
        
    }
    
}

