import UIKit
import AmaniSDK

/**
This class represents the cell class of Version Selector
*/
@objc(VersionSelectTableViewCell)
class VersionSelectTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var outerView = UIView()
    private var titleLabel = UILabel()
    
    // MARK: - Life cycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        self.selectionStyle = .none
    }
    // MARK: - Helper methods
    /**
     This method bind the data model with view
     - parameter model: DocumentVersion
     */
    func bindViewWith(model: DocumentVersion) {
        titleLabel.text = model.title ?? ""
    }
}

extension VersionSelectTableViewCell {
    private func setupUI() {
        let generalconfigs = try? Amani.sharedInstance.appConfig().getApplicationConfig().generalconfigs
        contentView.backgroundColor = hextoUIColor(hexString: generalconfigs?.appBackground ?? "#EEF4FA")
      
      self.outerView.translatesAutoresizingMaskIntoConstraints = false
      
      self.titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
      self.titleLabel.numberOfLines = 2
      self.titleLabel.textAlignment = .left
      
      self.outerView.addShadowWithBorder(shadowRadius: 4,
                                      shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25),
                                      shadowOpacity: 1, borderColor: .clear, borderWidth: 0,
                                      cornerRadious: CGFloat(generalconfigs?.buttonRadius ?? 10))
        
      self.titleLabel.textColor = hextoUIColor( hexString: generalconfigs?.primaryButtonTextColor ?? "000000")
      self.outerView.backgroundColor = hextoUIColor( hexString: generalconfigs?.primaryButtonBackgroundColor ?? "ffffff")
           if let bordercolor:String = generalconfigs?.primaryButtonBorderColor {
             self.outerView.addBorder(borderWidth: 2, borderColor: hextoUIColor(hexString: bordercolor).cgColor)
           }
        
        setConstraints()
    }
    
    private func setConstraints() {
        DispatchQueue.main.async { [self] in
            contentView.addSubview(outerView)
            outerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
               outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               
                
                titleLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: 65),
                titleLabel.bottomAnchor.constraint(equalTo: outerView.bottomAnchor),
                titleLabel.topAnchor.constraint(equalTo: outerView.topAnchor),
                titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 53),
                
            ])
        }
    }
    
}
