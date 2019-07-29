//
//  FormViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/11.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    var questions: [Question] = [] {
        didSet {
            self.formViews = Array(repeating: nil, count: questions.count)
            self.options = Array(repeating: [], count: questions.count)
            tablewView.reloadData()
        }
    }
    
    var sid: Int?
    
    private var formViews: [FormView?] = []
    private var options = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tablewView)
        tablewView.addSubview(button)
        button.addTarget(self, action: #selector(post), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let itemH: CGFloat = 200
    let formTableViewCellID = "formTableViewCellID"
    
    lazy var tablewView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.estimatedRowHeight = itemH
        tableView.tableFooterView = self.button
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: formTableViewCellID)
        return tableView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        button.setTitle("提交", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 25
        return button
    }()

}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formTableViewCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let question =  questions[indexPath.row]
        var formView: FormView?
        
        if question.type == 0 {
            formView = FormView(frame: CGRect(x: 0, y: 0, width: screenW, height: 250), questionStr: "\(indexPath.row + 1)、\(question.question)", optionList: question.optionList)
        } else {
            formView = CheckBoxView(frame: CGRect(x: 0, y: 0, width: screenW, height: 250), questionStr: "\(indexPath.row + 1)、\(question.question)", optionList: question.optionList)
        }

        cell.contentView.addSubview(formView!)
        formView!.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(cell.contentView)
        }
        formViews[indexPath.row] = formView
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        options[indexPath.row] = formViews[indexPath.row]!.selectIndexs
    }
}

extension FormViewController {
    @objc func post(sender: UIButton) {
        var answers = [SurveyAnswer]()
        for i in 0..<questions.count {
            let ques = questions[i]
            let form = formViews[i]
            for ops in form!.selectIndexs {
                let answer = SurveyAnswer(qid: "\(ques.qid)", options: ops, type: ques.type, answer: nil)
                answers.append(answer)
            }
        }
        if answers.count == questions.count{
            let encoder = JSONEncoder()
            let data = try! encoder.encode(answers)
            SurveyAPIs.postAnswer(sid: sid!, answer: String(data: data, encoding: .utf8)!)
        } else {
            self.tipWithLabel(msg: "请答完所有问题后提交")
        }
    }
}

extension FormViewController {
    func setUpNav(_ animated: Bool){
        self.title = "调查问卷"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
}


