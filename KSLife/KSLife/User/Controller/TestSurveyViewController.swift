//
//  TestSurveyViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/4.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class TestSurveyViewController: FormViewController {
    
    var simpleQ: [SimpleQuestion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getTestSurvey(success: {
            self.tablewView.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "体质检测"
    }
}

extension TestSurveyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + simpleQ.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formTableViewCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        if indexPath.row < simpleQ.count {
            let question = simpleQ[indexPath.row]
                let label = UILabel()
                label.text = "\(indexPath.row + 1)、" + question.question
                label.font = UIFont.systemFont(ofSize: 13)
                label.textColor = UIColor.gray
            let field = UITextField()
            field.backgroundColor = .white
            field.borderStyle = .roundedRect
            cell.contentView.addSubview(label)
            cell.contentView.addSubview(field)
            label.snp.makeConstraints { make in
                make.top.equalTo(cell.contentView).offset(margin)
                make.left.equalTo(cell.contentView).offset(margin)
            }
            field.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(margin)
                make.width.equalTo(cell.contentView).multipliedBy(0.9)
                make.centerX.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView).offset(-margin)
            }
        } else {
            let question =  questions[indexPath.row - simpleQ.count]
            var formView: FormView?
            
            formView = FormView(frame: CGRect(x: 0, y: 0, width: screenW, height: 250), questionStr: "\(indexPath.row + 1)、" + question.question.replacingOccurrences(of: "<br />", with: "\n"), optionList: question.optionList)
            
            cell.contentView.addSubview(formView!)
            formView!.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
}

extension TestSurveyViewController {
    func getTestSurvey(success: @escaping () -> Void) {
        SolaSessionManager.solaSession(url: SurveyAPIs.getTestSurvey, success: { dict in
            guard let data = dict["data"] as? [String: Any], let items = data["question"]  as? [[String: Any]] else {
                return
            }
            for item in items {
                guard let type = item["type"] as? Int else {
                    return
                }
                switch type {
                case 2:
                    if let question = item["question"] as? String, let qid = item["qid"] as? Int{
                        let qu = SimpleQuestion(qid: qid, question: question, type: type)
                        self.simpleQ.append(qu)
                    }
                case 0:
                    if let question = item["question"] as? String, let qid = item["qid"] as? Int, let optionList = item["optionList"] as? [String] {
                        let qu = Question(qid: qid, question: question, type: type, optionList: optionList)
                        self.questions.append(qu)
                    }
                default:
                    break
                }
            }
           success()
        }, failure: { _ in
            
        })
    }
}
