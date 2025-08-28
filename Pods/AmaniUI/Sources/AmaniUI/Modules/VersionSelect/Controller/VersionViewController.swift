import UIKit
import AmaniSDK

/**
 The VersionViewController class is used to provide a user interface for version selection screen.
 */

class VersionViewController: BaseViewController {
    
  // MARK: - Properties
    private var headerView = UIView()
    private var descriptionLabel = UILabel()
    
    private var versionSelectionTblView = UITableView()
    private var amaniLogo = UIImageView()

  // MARK: - Local properties
  
  /// This property holds the current instance of DocumentRunnerHelper
  var documentHandler: DocumentHandlerHelper?
  
  /// This property represents the Document title
  var docTitle: String = ""
  
  /// This property represents the Document description
  var docDescription: String = ""
  
  /// This property represents the step of the Document Belongs to
  var stepVM: KYCStepViewModel!
  
  // MARK: - Life cycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    
    self.setTableView()
  }
  
  // MARK: - initial set up methods
  /**
   This method used to set up initial state on view
   */
  func setupUI() {
    let generalConfigs = try! Amani.sharedInstance.appConfig().getApplicationConfig().generalconfigs
    let navFontColor = generalConfigs?.topBarFontColor ?? "ffffff"
    let textColor =  generalConfigs?.appFontColor ?? "ffffff"
    
    self.headerView.backgroundColor = .clear
    self.headerView.translatesAutoresizingMaskIntoConstraints = false
    
    
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    self.descriptionLabel.textAlignment = .left
    self.descriptionLabel.numberOfLines = 0
    self.descriptionLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    
    self.amaniLogo = UIImageView(image: UIImage(named: "ic_poweredBy", in: AmaniUI.sharedInstance.getBundle(), with: nil)?.withRenderingMode(.alwaysTemplate))
    self.amaniLogo.translatesAutoresizingMaskIntoConstraints = false
    self.amaniLogo.contentMode = .scaleAspectFit
    self.amaniLogo.clipsToBounds = true
    self.amaniLogo.tintAdjustmentMode = .normal
    
    
     
    self.setNavigationBarWith(title: self.docTitle,textColor: hextoUIColor(hexString: navFontColor))
    self.setNavigationLeftButton(TintColor: navFontColor)
    self.descriptionLabel.text = docDescription
    self.versionSelectionTblView.backgroundColor = hextoUIColor(hexString: generalConfigs?.appBackground ?? "#EEF4FA")
    descriptionLabel.textColor = hextoUIColor(hexString: textColor)
    amaniLogo.isHidden = generalConfigs?.hideLogo ?? false
    amaniLogo.tintColor = hextoUIColor(hexString: textColor)
    
    
    setConstraints()
     
  }
  
  // MARK: - Helper methods
  func bind(runnerHelper: DocumentHandlerHelper, docTitle: String, docDescription: String, step: KYCStepViewModel) {
    self.documentHandler = runnerHelper
    self.docTitle = docTitle
    self.docDescription = docDescription
    self.stepVM = step
  }
}

// MARK: - Table view datasource and delegate methods
extension VersionViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.documentHandler!.versionList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "VersionSelectTableViewCell", for: indexPath) as? VersionSelectTableViewCell else {
          return UITableViewCell()
      }

    cell.bindViewWith(model: documentHandler!.versionList[indexPath.row])
    return cell
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let runner = documentHandler else { return }
    
    let document: DocumentVersion = runner.versionList[indexPath.row]
    documentHandler?.onVersionPressed(version: document)
    
  }
  
}

extension VersionViewController {
    private func setTableView() {
        versionSelectionTblView.translatesAutoresizingMaskIntoConstraints = false
        versionSelectionTblView.delegate = self
        versionSelectionTblView.dataSource = self
        versionSelectionTblView.register(VersionSelectTableViewCell.self, forCellReuseIdentifier: String(describing: VersionSelectTableViewCell.self))
        versionSelectionTblView.isScrollEnabled = true
        versionSelectionTblView.showsVerticalScrollIndicator = false
        versionSelectionTblView.showsHorizontalScrollIndicator = false
        versionSelectionTblView.separatorStyle = .none
        versionSelectionTblView.reloadData()

    }
    
    private func setConstraints() {
        
        self.view.addSubview(headerView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(versionSelectionTblView)
        self.view.addSubview(amaniLogo)
        amaniLogo.tintColor = hextoUIColor(hexString: "#909090")
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor, constant: -40),
            headerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.059),
            
            descriptionLabel.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.versionSelectionTblView.topAnchor, constant: -40),
            
            versionSelectionTblView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 40),
            versionSelectionTblView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            versionSelectionTblView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            versionSelectionTblView.bottomAnchor.constraint(equalTo: amaniLogo.topAnchor, constant: -20),
            
            amaniLogo.widthAnchor.constraint(equalToConstant: 114),
            amaniLogo.heightAnchor.constraint(equalToConstant: 13),
            amaniLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            amaniLogo.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            
        
        ])
    }
}
