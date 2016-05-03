--花札衛－柳に小野道風－
--Cardian - Yanagi ni Ono no Michikaze
--Script by dest
function c100206101.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c100206101.hspcon)
	e1:SetOperation(c100206101.hspop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206101,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c100206101.target)
	e2:SetOperation(c100206101.operation)
	c:RegisterEffect(e2)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c100206101.syntg)
	e3:SetValue(1)
	e3:SetOperation(c100206101.synop)
	c:RegisterEffect(e3)
end
function c100206101.hspfilter(c)
	return c:IsSetCard(0x1e5) and c:GetLevel()==11 and not c:IsCode(100206101)
end
function c100206101.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c100206101.hspfilter,1,nil)
end
function c100206101.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c100206101.hspfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100206101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100206101.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc and Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.BreakEffect()
		if ft>0 and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1e5)
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(100206101,1)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c100206101.cardiansynlevel(c)
	return 2
end
function c100206101.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c100206101.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv2=syncard:GetLevel()-c100206101.cardiansynlevel(c)
	if lv<=0 and lv2<=0 then return false end
	local g=Duel.GetMatchingGroup(c100206101.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c100206101.cardiansynlevel,lv2,minc,maxc)
	return res or res2
end
function c100206101.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv2=syncard:GetLevel()-c100206101.cardiansynlevel(c)
	local g=Duel.GetMatchingGroup(c100206101.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c100206101.cardiansynlevel,lv2,minc,maxc)
	local sg=nil
	if (res2 and res and Duel.SelectYesNo(tp,aux.Stringid(100206101,2)))
		or (res2 and not res) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,c100206101.cardiansynlevel,lv2,minc,maxc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	end
	Duel.SetSynchroMaterial(sg)
end
