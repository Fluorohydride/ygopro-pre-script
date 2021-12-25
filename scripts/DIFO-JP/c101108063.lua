--天気予報

--Script by Chrono-Genex
function c101108063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108063+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101108063.activate)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCountLimit(1,101108063+100)
	e2:SetTarget(c101108063.mattg)
	e2:SetValue(c101108063.matval)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108063,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,101108063+200)
	e3:SetTarget(c101108063.sumtg)
	e3:SetOperation(c101108063.sumop)
	c:RegisterEffect(e3)
	if not aux.link_mat_hack_check then
		aux.link_mat_hack_check=true
		_IsCanBeLinkMaterial=Card.IsCanBeLinkMaterial
		function Card.IsCanBeLinkMaterial(c,lc)
			if c:GetOriginalType()&TYPE_MONSTER~=0 then
				return _IsCanBeLinkMaterial(c,lc)
			end
			if c:IsForbidden() then return false end
			local le={c:IsHasEffect(EFFECT_CANNOT_BE_LINK_MATERIAL)}
			for _,te in pairs(le) do
				local tf=te:GetValue()
				local tval=tf(te,lc)
				if tval then return false end
			end
			return true
		end
	end
end
function c101108063.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSetCard(0x109)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101108063.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101108063.tffilter,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(101108063,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c101108063.mattg(e,c)
	return c:IsSetCard(0x109) and c:GetSequence()<5
end
function c101108063.matval(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0x109) and e:GetHandlerPlayer()==tp) then return false,nil end
	return true,true
end
function c101108063.sumfilter(c)
	return c:IsSetCard(0x109) and c:IsSummonable(true,nil)
end
function c101108063.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108063.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101108063.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c101108063.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
