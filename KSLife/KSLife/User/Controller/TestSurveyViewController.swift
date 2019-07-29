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
    private var fields: [UITextField] = []
    private var formViews: [FormView?] = []
    private var fieldTexts = [String]()
    private var needStr = ""
    private var options = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getTestSurvey(success: {
            self.fields = Array(repeating: UITextField(), count: 4)
            self.fieldTexts = Array(repeating: "", count: 4)
            self.formViews = Array(repeating: nil, count: self.questions.count)
            self.options = Array(repeating: [], count: self.questions.count)
            self.tablewView.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "体质检测"
    }
    
    override func post(sender: UIButton) {
        var answers = [SurveyAnswer]()
        for i in 0..<fields.count {
            let ques = simpleQ[i]
            let field = fields[i]
            if let text = field.text {
                let answer = SurveyAnswer(qid: "\(ques.qid)", options: nil, type: 2, answer: text)
                answers.append(answer)
            }
        }
        for i in 0..<questions.count {
            let ques = questions[i]
            let form = formViews[i]
            for ops in form!.selectIndexs {
                let answer = SurveyAnswer(qid: "\(ques.qid)", options: ops, type: ques.type, answer: nil)
                answers.append(answer)
            }
        }
        let ques = simpleQ[simpleQ.count - 1]
        let answer = SurveyAnswer(qid: "\(ques.qid)", options: nil, type: ques.type, answer: dropBtn.titleLabel?.text)
        answers.append(answer)
        
        if answers.count == simpleQ.count + questions.count {
            let alert = UIAlertController.init(title: "确认提示", message: "提交体质检测后将初始化系统，请慎重选择或取消提交", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                let encoder = JSONEncoder()
                let data = try! encoder.encode(answers)
                SurveyAPIs.postAnswer(sid: self.sid ?? 1, answer: String(data: data, encoding: .utf8)!)
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.tipWithLabel(msg: "请答完所有问题后提交")
        }
    }
    
    private lazy var dropBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
        button.setTitle("请选择", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor(hex6: 0xdbdbdb).cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var dropDownMenu: DropDownMenu = {[unowned self] in
        let menu = DropDownMenu()
        menu.deleget = self
        menu.tag = 1000
        return menu
        }()
}

extension TestSurveyViewController: DropDownMenuDelegate{
    func setDropDownDelegate(str: String?) {
        dropBtn.setTitle(str, for: .normal)
        needStr = str ?? ""
    }
    
    @objc func dropDown(sender: UIButton) {
        let arr = ["均衡饮食","减肥","控糖","怀孕0-3个月","怀孕3-6个月","怀孕7-10个月","哺乳期","肝胆康复", "临床营养康复", "消化康复", "内分泌外科康复", "心内科康复", "泌尿科康复", "代谢科康复", "内分泌内科康复", "其他"]
        setupDropDownMenu(dropDownMenu: dropDownMenu, titleArray: arr, button: sender)
    }
    
    func setupDropDownMenu(dropDownMenu: DropDownMenu, titleArray: [String], button: UIButton) {
        let btnFrame = getBtnFrame(button)
        
        if (dropDownMenu.tag == 1000) {
            dropDownMenu.showDropDownMenu(button: button, withButtonFrame: btnFrame, arrayOfTitle: titleArray)
            self.view.addSubview(dropDownMenu)
            dropDownMenu.tag = 2000
        } else {
            dropDownMenu.hideDropDownMenuWithBtnFrame(btnFrame: btnFrame)
            dropDownMenu.tag = 1000
        }
    }
    
    func getBtnFrame(_ button: UIButton) -> CGRect{
        button.layoutIfNeeded()
        return button.superview!.convert(button.frame, to: self.view)
    }
    
    func sureToPost() {
        
//
//        let encoder = JSONEncoder()
//        let data = try! encoder.encode(answers)
//        postAnswer(sid: sid ?? 1, answer: String(data: data, encoding: .utf8)!)
    }
}

extension TestSurveyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + simpleQ.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row < simpleQ.count - 1 {
            let question = simpleQ[indexPath.row]
                let label = UILabel()
                label.text = "\(indexPath.row + 1)、" + question.question
                label.font = UIFont.systemFont(ofSize: 13)
                label.textColor = UIColor.gray
            let field = UITextField()
            field.text = fieldTexts[indexPath.row]
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
            fields[indexPath.row] = field
        } else if indexPath.row == simpleQ.count - 1 {
            let question = simpleQ[indexPath.row]
            let label = UILabel()
            label.text = "\(indexPath.row + 1)、" + question.question
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.gray
            
            cell.contentView.addSubview(label)
            cell.contentView.addSubview(dropBtn)
            label.snp.makeConstraints { make in
                make.top.equalTo(cell.contentView).offset(margin)
                make.left.equalTo(cell.contentView).offset(margin)
            }
            dropBtn.setTitle(needStr, for: .normal)
            dropBtn.snp.makeConstraints { make in
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
            formView?.selectIndexs = options[indexPath.row - simpleQ.count]
            formViews[indexPath.row - simpleQ.count] = formView
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let n = indexPath.row
        if n < simpleQ.count - 1 {
            guard let text = fields[n].text else {
                return
            }
            fieldTexts[n] = text
        } else if n > simpleQ.count - 1{
            options[n - simpleQ.count] = formViews[n - simpleQ.count]!.selectIndexs
        }
    }
}

extension TestSurveyViewController {
    func getTestSurvey(success: @escaping () -> Void) {
        SolaSessionManager.solaSession(url: SurveyAPIs.getTestSurvey, success: { dict in
            guard let data = dict["data"] as? [String: Any], let items = data["question"]  as? [[String: Any]], let sid = data["sid"] as? Int else {
                return
            }
            self.sid = sid ?? 1
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
