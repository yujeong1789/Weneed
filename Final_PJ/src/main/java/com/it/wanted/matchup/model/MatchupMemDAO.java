package com.it.wanted.matchup.model;

import java.util.List;
import java.util.Map;

public interface MatchupMemDAO {

	/* 자연 */
	public int isMechupMem(int memNo);
	public int selectmcuResumeNo(int memNo);
	
	/* 현빈 */
	List<MatchupMemVO> selectOpen();
	List<Map<String, Object>> selectTenMem(int firstRecord);
	public int selectMcumemNo(int resumeNo);
	public List<Map<String, Object>> selectMcumemSearchList(MatchupMemSearchVO mcuMemSearchVo);
	public List<Map<String, Object>> selectZzimedList(List<Map<String, Object>> mcumemSearchResultList);

}
