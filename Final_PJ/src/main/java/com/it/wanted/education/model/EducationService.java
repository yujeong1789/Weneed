package com.it.wanted.education.model;

import java.util.List;

public interface EducationService {
	public int insertEdu(EducationVO educationVo);
	public EducationVO selectEdu(int resumeNo);
	public int deleteEdu(int eduNo);
	public List<EducationVO> selectEduByResumeNo(int resumeNo);

}
