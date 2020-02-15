--黄金郷のコンキスタドール
--
--Script by JustFish
function c100414034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100414034)
	e1:SetTarget(c100414034.target)
	e1:SetOperation(c100414034.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100414034,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100414034)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100414034.settg)
	e2:SetOperation(c100414034.setop)
	c:RegisterEffect(e2)
end
function c100414034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,100414034,0,0x11,500,1800,5,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100414034.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100414034,0,0x11,500,1800,5,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,100414027) and  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(100414034,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c100414034.setfilter(c)
	return c:IsSetCard(0x24c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100414034.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100414034.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100414034.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100414034.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
