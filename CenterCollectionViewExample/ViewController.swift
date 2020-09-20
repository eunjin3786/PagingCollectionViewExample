import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.bounds.width - 40, height: self.view.bounds.height - 80)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal
            layout.headerReferenceSize = CGSize(width: 200, height: self.view.bounds.height - 80)
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
        targetContentOffset.pointee = point
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
            self.collectionView.setContentOffset(point, animated: true)
        }, completion: nil)
    }
    
    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = currentPage - 1
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = currentPage + 1
        }
        
        let additional = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) - flowLayout.headerReferenceSize.width
        
        let updatedOffset = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) * CGFloat(currentPage) - additional
        
        previousOffset = updatedOffset
        
        return CGPoint(x: updatedOffset, y: 0)
    }
}
