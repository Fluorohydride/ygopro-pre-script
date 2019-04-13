--リバーシブル・ビートル

--Script by nekrozar
function c101009035.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009035,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101009035)
	e1:SetTarget(c101009035.postg)
	e1:SetOperation(c101009035.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101009035,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e3:SetCountLimit(1,101009135)
	e3:SetTarget(c101009035.tdtg)
	e3:SetOperation(c101009035.tdop)
	c:RegisterEffect(e3)
end
function c101009035.posfilter(c,g)
	return g:IsContains(c) and c:IsCanTurnSet()
end
function c101009035.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	local g=Duel.GetMatchingGroup(c101009035.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c101009035.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c101009035.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c101009035.tdfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsAbleToDeck()
end
function c101009035.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if not c:IsStatus(STATUS_BATTLE_DESTROYED) then cg:AddCard(c) end
	local g=Duel.GetMatchingGroup(c101009035.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c101009035.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if not c:IsStatus(STATUS_BATTLE_DESTROYED) then cg:AddCard(c) end
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c101009035.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
