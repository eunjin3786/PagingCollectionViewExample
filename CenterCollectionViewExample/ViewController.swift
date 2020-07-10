import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = CustomCollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.bounds.width - 40, height: self.view.bounds.height - 80)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal
            layout.headerReferenceSize = CGSize(width: 100, height: self.view.bounds.height - 80)
            layout.footerReferenceSize = CGSize(width: 350, height: self.view.bounds.height - 80)
            return layout
        }()
        
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SampleCell", for: indexPath)
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .green
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
//        let index: Int
//        if velocity.x > 0 {
//            index = Int(ceil(estimatedIndex))
//        } else if velocity.x < 0 {
//            index = Int(floor(estimatedIndex))
//        } else {
//            index = Int(round(estimatedIndex))
//        }
//
//        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
//    }
}

// https://stackoverflow.com/questions/23990863/uicollectionview-cell-scroll-to-centre
class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
//    override var collectionViewContentSize: CGSize {
//        let originalContentSize = super.collectionViewContentSize
//        return CGSize(width: originalContentSize.width + 40, height: originalContentSize.height)
//    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = currentPage - 1
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = currentPage + 1
        }
        
        let additional = itemSize.width -         headerReferenceSize.width + minimumLineSpacing
        
        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - additional
        
//        let maxContentOffset: CGFloat = {
//            let totalCellCount = collectionView.numberOfItems(inSection: 0)
//            let totalCellWidth = CGFloat(totalCellCount) * (itemSize.width + minimumLineSpacing)
//            let headerFooterWidth = headerReferenceSize.width + footerReferenceSize.width
//            let totalContentSize = totalCellWidth + headerFooterWidth + sectionInset.left + sectionInset.right
//            return totalContentSize - collectionView.bounds.width - sectionInset.right - minimumLineSpacing
//        }()
//
//        if updatedOffset > maxContentOffset {
//            updatedOffset = maxContentOffset
//        }
        
        previousOffset = updatedOffset
//        print(updatedOffset)
//        print("max \(maxContentOffset)")
//
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}
