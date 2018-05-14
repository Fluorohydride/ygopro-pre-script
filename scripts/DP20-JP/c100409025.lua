--BF－南風のアウステル
--Blackwing - Auster the South Wind
--Script by dest
function c100409025.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100409025,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c100409025.sumtg)
	e2:SetOperation(c100409025.sumop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100409025,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c100409025.target)
	e3:SetOperation(c100409025.operation)
	c:RegisterEffect(e3)
end
function c100409025.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100409025.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100409025.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100409025.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100409025.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100409025.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100409025.bfcfilter(c)
	return c:IsFaceup() and c:IsCode(9012916)
end
function c100409025.wcfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1002)==0
end
function c100409025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100409025.bfcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	local b2=Duel.IsExistingMatchingCard(c100409025.wcfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100409025,2),aux.Stringid(100409025,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100409025,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100409025,3))+1
	end
	e:SetLabel(op)
end
function c100409025.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,c100409025.bfcfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if tc and ct>0 then
			tc:AddCounter(0x10,ct)
		end
	else
		local g=Duel.GetMatchingGroup(c100409025.wcfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			tg:AddCounter(0x1002,1)
			tc=g:GetNext()
		end
	end
end
