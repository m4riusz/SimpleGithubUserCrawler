import UIKit

enum EmptyMaskViewType {
    case none
    case emptySearchText
    case noUsersFilterResult
    case notSelectedUser
    case noInternetConnection
}

class EmptyMaskView: NibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupForType(_ type: EmptyMaskViewType) -> Void {
        var title, description: String
        
        switch type {
        case .none:
            title = ""
            description = ""
        case .noUsersFilterResult:
            title = "Nie znaleziono użytkowników"
            description = "Nie znaleziono użytkowników pasujących do podanej frazy"
        case .emptySearchText:
            title = "Wyszukiwarka"
            description = "Wpisz nazwę użytkownika, aby go wyszukać"
        case .notSelectedUser:
            title = "Brak szczegółów"
            description = "Wybierz użytkownika aby zobaczyć więcej informacji"
        case .noInternetConnection:
            title = "Błąd"
            description = "Nie można pobrać szczegółów użytkownika. Sprawdź swoje połączenie z internetem."
        }
        
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}
