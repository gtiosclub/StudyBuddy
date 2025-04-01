//
//  ProgessBarView.swift
//  StudyBuddy
//
//  Created by Austin Renz on 3/30/25.
//

import SwiftUI

struct ProgessBarView: View {
    @State private var termsMastered: Int=22
    let totalTerms: Int=48
    
    var progressValue: Double{
        Double(termsMastered)/Double(totalTerms)
    }
    
    var percentageValue:Int{
        Int(progressValue*100)
    }
    var body: some View{
        VStack{
            
            VStack(alignment: .leading){
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(Color(.darkGray))
                    
                HStack(spacing:0){
                    Text("\(percentageValue)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(Color(.white))
                        .padding(.bottom,5)
                    
                    Text("%")
                        .font(.system(size: 80))
                        .foregroundColor(Color(.white))
                }
                Text("\(termsMastered)/\(totalTerms) terms mastered")
                    .font(.subheadline)
                    .foregroundColor(Color(.darkGray))
                    .padding(.bottom,8)
                ProgressView(value:progressValue)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(Color.gray)
                    .scaleEffect(x:1,y:2,anchor:.center)
                    .padding(.bottom, 8)

            }
            .padding()
            .background(RoundedRectangle(cornerRadius:10)
                .fill(Color(.systemGray4))
            )
            .padding()
        }
    }
}

#Preview {
    ProgessBarView()
}
